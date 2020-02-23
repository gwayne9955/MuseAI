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

//A view controller is the window through which a user views the app elements; without it, the screen would just be black/white
class KeyboardViewController: UIViewController {
    
    //    func canRotate() -> Void {}
    let synth = Synth()
    let patch = 0
    var aKKeyboardView: AKKeyboardView?
    var readyToSendToAI = false
    var notesInputted: [MIDINoteNumber] = []
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
        
        
        print("Note on: \(note)")
        synth.playNoteOn(channel: 0, note: note, midiVelocity: 127)
        self.notesInputted.append(note)
        if firstNoteTime == 0 {
            firstNoteTime = Date().toMillis()!
        }
        
        print(Date().toMillis()! - firstNoteTime)
        self.notesPressed.insert(note)
        
        self.workItem?.cancel()
        
    }
    
    func noteOff(note: MIDINoteNumber) { // note is a UInt8
        print("Note off: \(note)")
        synth.playNoteOff(channel: 0, note: UInt32(note), midiVelocity: 127)
        self.notesPressed.remove(note)
        print(Date().toMillis()! - firstNoteTime)
//        self.notes.popLast()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
//            self.aKKeyboardView!.programmaticNoteOn(85)
//            self.noteOn(note: 85)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                self.aKKeyboardView!.programmaticNoteOff(85)
//                self.noteOff(note: 85)
//
//            })
//
//        })
        if !readyToSendToAI {
            readyToSendToAI = true
        }
        self.workItem = DispatchWorkItem {
            let newNotes = self.notesInputted
            self.notesInputted.removeAll()
            self.firstNoteTime = 0
            if !newNotes.isEmpty {
                print("AI getting \(newNotes)")
            }
        }
        
        if readyToSendToAI && self.notesPressed.isEmpty {
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
