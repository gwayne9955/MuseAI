//
//  KeyboardViewController.swift
//  MuseAI
//
//  Created by Garrett Wayne on 2/8/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import UIKit
import AudioKit
import AudioKitUI
import AudioToolbox

struct NoteEvent {
    var noteVal: MIDINoteNumber
    var noteOn: Bool
    var timeOffset: Int64
}

struct NoteWorker {
    var offset: Double
    var worker: DispatchWorkItem
}

//A view controller is the window through which a user views the app elements; without it, the screen would just be black/white
class KeyboardViewController: UIViewController {
    
    //    func canRotate() -> Void {}
    let synth = Synth()
    let patch = 0
    var aKKeyboardView: AKKeyboardView?
    var notesInputted: [NoteEvent] = []
    var notesPressed = Set<MIDINoteNumber>()
    var workItem: DispatchWorkItem?
    var firstNoteTime: Int64 = 0
    
    //This function loads the view controller (window through which users view app elements)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        //        UIDevice.current.setValue(value, forKey: "orientation")
        // Do any additional setup after loading the view, typically from a nib.
        setSpeakersAsDefaultAudioOutput()
        loadVoices()
        
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
        //            self.loadKeyboard()
        //        })
        loadKeyboard()
    }
    
    //    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //        return .landscape
    //    }
    //
    //    override var shouldAutorotate: Bool {
    //        return true
    //    }
    
    // work around for when some devices only play through the headphone jack
    func setSpeakersAsDefaultAudioOutput() {
        do {
            try
                AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        }
        catch {
            // hard to imagine how we'll get this exception
            let alertController = UIAlertController(title: "Speaker Problem", message: "You may be able to hear sound using headphones.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                (result: UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //We need to define a function before we call it
    func loadKeyboard() {
        //Were going to set a new variable that is the actual piano keyboard
        //We need to define something, our keyboard in this case, in order for it to appear
        aKKeyboardView = AKKeyboardView(frame: ScreenControl.manageSize(rect: CGRect(x: 0, y:200, width: 800, height: 250)))
        //Finally, we need to add our new keyboardView to our View Controller for it to appear
        self.view.addSubview(aKKeyboardView!)
        aKKeyboardView!.delegate = self
        aKKeyboardView!.polyphonicMode = true
    }
    
    func loadVoices() {
        DispatchQueue.global(qos: .background).async {
            self.synth.loadPatch(patchNo: self.patch)
            DispatchQueue.main.async {
                
            }
        }
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //
    //        if (self.isMovingFromParent) {
    //          UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    //        }
    //
    //    }
    
}

extension KeyboardViewController: AKKeyboardDelegate {
    
    func noteOn(note: MIDINoteNumber) { // note is a UInt8
        if firstNoteTime == 0 {
            firstNoteTime = Date().toMillis()!
        }
        
        self.notesInputted.append(NoteEvent(
            noteVal: MIDINoteNumber((Int(note - 24)) % (self.synth.octave * 12)),
            noteOn: true,
            timeOffset: Date().toMillis()! - firstNoteTime))
        
        print("Note on: \(note)")
        synth.playNoteOn(channel: 0, note: note, midiVelocity: 127)
        
        print(Date().toMillis()! - firstNoteTime)
        self.notesPressed.insert(note)
        
        self.workItem?.cancel()
        
    }
    
    func noteOff(note: MIDINoteNumber) { // note is a UInt8
        self.notesInputted.append(NoteEvent(
            noteVal: MIDINoteNumber((Int(note - 24)) % (self.synth.octave * 12)),
            noteOn: false,
            timeOffset: Date().toMillis()! - firstNoteTime))
        
        print("Note off: \(note)")
        synth.playNoteOff(channel: 0, note: UInt32(note), midiVelocity: 127)
        self.notesPressed.remove(note)
        print(Date().toMillis()! - firstNoteTime) // every value of 1000 is a second
        
        self.workItem = DispatchWorkItem {
            let newNotes = self.notesInputted
            self.notesInputted.removeAll()
            self.firstNoteTime = 0
            
            if !newNotes.isEmpty {
                let notesFromAI = AINotes.getAINotes(notesInputted: newNotes, firstNoteTime: self.firstNoteTime) // send notes to AI here
                var workers: [NoteWorker] = []
                
                for note in notesFromAI { // iterate through what the AI returns
                    let offset: Double = Double(note.timeOffset) / 1000.0
                    let midiNote = note.noteVal + MIDINoteNumber(self.synth.octave * 12) + 24
                    
                    if note.noteOn {
                        workers.append(NoteWorker(offset: offset, worker: DispatchWorkItem {
                            self.aKKeyboardView?.programmaticNoteOn(midiNote)
                            self.synth.playNoteOn(channel: 0, note: midiNote, midiVelocity: 127)
                        }))
                    }
                    else {
                        workers.append(NoteWorker(offset: offset, worker: DispatchWorkItem {
                            self.aKKeyboardView?.programmaticNoteOff(midiNote)
                            self.synth.playNoteOff(channel: 0, note: UInt32(midiNote), midiVelocity: 127)
                        }))
                    }
                }
                
                for w in workers {
                    DispatchQueue.main.asyncAfter(deadline: .now() + w.offset, execute: w.worker)
                }
            }
        }
        
        if self.notesPressed.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: self.workItem!)
        }
    }
}

//extension UINavigationController {
//
//override open var shouldAutorotate: Bool {
//    get {
//        if let visibleVC = visibleViewController {
//            return visibleVC.shouldAutorotate
//        }
//        return super.shouldAutorotate
//    }
//}
//
//override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
//    get {
//        if let visibleVC = visibleViewController {
//            return visibleVC.preferredInterfaceOrientationForPresentation
//        }
//        return super.preferredInterfaceOrientationForPresentation
//    }
//}
//
//override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
//    get {
//        if let visibleVC = visibleViewController {
//            return visibleVC.supportedInterfaceOrientations
//        }
//        return super.supportedInterfaceOrientations
//    }
//}}


extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
