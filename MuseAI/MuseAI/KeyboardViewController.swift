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
import AsyncHTTPClient
import Resolver

struct NoteEvent: Codable {
    var noteVal: MIDINoteNumber
    var noteOn: Bool
    var timeOffset: Int64
}

struct NoteWorker {
    var offset: Double
    var worker: DispatchWorkItem
}

var httpClient: HTTPClient = HTTPClient(eventLoopGroupProvider: .createNew)

//A view controller is the window through which a user views the app elements; without it, the screen would just be black/white
class KeyboardViewController: UIViewController {
    
    @Injected var recordingRepository: RecordingRepository
    let synth = Synth()
    let patch = 0
    var aKKeyboardView: AKKeyboardView?
    var notesInputted: [NoteEvent] = []
    var notesRecorded: [NoteEvent] = []
    var notesPressed = Set<MIDINoteNumber>()
    var workItem: DispatchWorkItem?
    var firstNoteTime: Int64 = 0
    var timeRecordIsHit: Int64 = 0
    var isRecording: Bool = false
    var recordStartedDuringHumanInteraction: Bool = false
    
    //This function loads the view controller (window through which users view app elements)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setSpeakersAsDefaultAudioOutput()
        loadVoices()
        loadKeyboard()
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .red
        button.setTitle("Record", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
    
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        if !isRecording {
            timeRecordIsHit = Date().toMillis()!
            isRecording = true
            sender.setTitle("Recording...", for: .normal)
        }
        else {
            isRecording = false
            recordStartedDuringHumanInteraction = false
            sender.setTitle("Record", for: .normal)
            if notesRecorded.count > 1 {
                processRecording()
            }
        }
    }
    
    func processRecording() {
        print("Recorded Notes are:")
        print(notesRecorded)
        
        recordingRepository.addRecording(Recording(title: "Recording from keyboard", notes: notesRecorded))
        
        notesRecorded.removeAll()
    }
    
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
}

extension KeyboardViewController: AKKeyboardDelegate {
    
    func noteOn(note: MIDINoteNumber) { // note is a UInt8
        let now = Date()
        if firstNoteTime == 0 {
            firstNoteTime = now.toMillis()!
        }
        
        self.notesInputted.append(NoteEvent(
            noteVal: MIDINoteNumber((Int(note - 24)) % (self.synth.octave * 12)),
            noteOn: true,
            timeOffset: now.toMillis()! - firstNoteTime))
        
        if isRecording {
            recordStartedDuringHumanInteraction = true
            self.notesRecorded.append(NoteEvent(
                noteVal: MIDINoteNumber((Int(note - 24)) % (self.synth.octave * 12)),
                noteOn: true,
                timeOffset: now.toMillis()! - timeRecordIsHit))
        }
        
        print("Note on: \(note)")
        synth.playNoteOn(channel: 0, note: note, midiVelocity: 127)
        
        print(now.toMillis()! - firstNoteTime)
        self.notesPressed.insert(note)
        self.workItem?.cancel()
        
    }
    
    func noteOff(note: MIDINoteNumber) { // note is a UInt8
        let now = Date()
        self.notesInputted.append(NoteEvent(
            noteVal: MIDINoteNumber((Int(note - 24)) % (self.synth.octave * 12)),
            noteOn: false,
            timeOffset: now.toMillis()! - firstNoteTime))
        
        if isRecording {
            self.notesRecorded.append(NoteEvent(
                noteVal: MIDINoteNumber((Int(note - 24)) % (self.synth.octave * 12)),
                noteOn: false,
                timeOffset: now.toMillis()! - firstNoteTime))
        }
        
        print("Note off: \(note)")
        synth.playNoteOff(channel: 0, note: UInt32(note), midiVelocity: 127)
        self.notesPressed.remove(note)
        print(now.toMillis()! - firstNoteTime) // every value of 1000 is a second
        
        self.workItem = DispatchWorkItem {
            let newNotes = self.notesInputted
            self.notesInputted.removeAll()
            self.firstNoteTime = 0
            
            if !newNotes.isEmpty {
                AINotes.getAINotes(notesInputted: newNotes, firstNoteTime: self.firstNoteTime, callback: { result in
                    var workers: [NoteWorker] = []
                    var notesReturned: [NoteEvent] = []
                    
                    switch result {
                        case .failure(_):
                            notesReturned = self.notesInputted
                            break
                        case .success(var response):
                            do {
                                let melodyResponse = try response.body!.readJSONDecodable(MelodyResponse.self, length: response.body!.readableBytes)
                                //pass newnotes to distribute, then drop them there
                                let notes = distributeNotes(noteSequences: melodyResponse!.notes, timeOffsetToSubtract: newNotes[newNotes.count - 1].timeOffset, numberOfNotesToDrop: newNotes.count)
                                notesReturned = notes
                                print("Notes Returned:")
                                print(notesReturned)
                                
                            } catch  {
                                print("Error From AI Server, returning notes entered")
                                notesReturned = newNotes
                            }
                    }
                    
                    for note in notesReturned { // iterate through what the AI returns
                        
                        let offset: Double = Double(note.timeOffset) / 1000.0
                        let midiNote = note.noteVal + MIDINoteNumber(self.synth.octave * 12) + 24
                        
                        if note.noteOn {
                            workers.append(NoteWorker(offset: offset, worker: DispatchWorkItem {
                                if self.isRecording {
                                    var timeOffset = Date().toMillis()! - self.timeRecordIsHit
                                    if self.recordStartedDuringHumanInteraction {
                                        timeOffset = note.timeOffset + newNotes[newNotes.count - 1].timeOffset
                                    }
                                    self.notesRecorded.append(NoteEvent(
                                        noteVal: note.noteVal,
                                        noteOn: note.noteOn,
                                        timeOffset: timeOffset))
                                }
                                
                                self.aKKeyboardView?.programmaticNoteOn(midiNote)
                                self.synth.playNoteOn(channel: 0, note: midiNote, midiVelocity: 127)
                            }))
                        }
                        else {
                            workers.append(NoteWorker(offset: offset, worker: DispatchWorkItem {
                                if self.isRecording {
                                    var timeOffset = Date().toMillis()! - self.timeRecordIsHit
                                    if self.recordStartedDuringHumanInteraction {
                                        timeOffset = note.timeOffset + newNotes[newNotes.count - 1].timeOffset
                                    }
                                    self.notesRecorded.append(NoteEvent(
                                        noteVal: note.noteVal,
                                        noteOn: note.noteOn,
                                        timeOffset: timeOffset))
                                }
                                
                                self.aKKeyboardView?.programmaticNoteOff(midiNote)
                                self.synth.playNoteOff(channel: 0, note: UInt32(midiNote), midiVelocity: 127)
                            }))
                        }
                    }
                    
                    let dispatchTime = DispatchTime.now()
                    
                    for w in workers {
                        DispatchQueue.main.asyncAfter(deadline: dispatchTime + w.offset, execute: w.worker)
                    }
                })
            }
        }
        
        if self.notesPressed.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: self.workItem!)
        }
    }
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
