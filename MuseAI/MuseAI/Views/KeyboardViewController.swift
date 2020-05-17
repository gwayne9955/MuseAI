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

class KeyboardViewController: UIViewController {
    
    @Injected var recordingPersistence: RecordingPersistence
    let synth = Synth()
    var patch = Instruments.piano.patch
    var aKKeyboardView: AKKeyboardView?
    var notesInputted: [NoteEvent] = []
    var notesRecorded: [NoteEvent] = []
    var notesPressed = Set<MIDINoteNumber>()
    var workItem: DispatchWorkItem?
    var firstNoteTime: Int64 = 0
    var timeRecordIsHit: Int64 = 0
    var isRecording: Bool = false
    var recordStartedDuringHumanInteraction: Bool = false
    var aiToPlay: Bool = false
    
    //This function loads the view controller (window through which users view app elements)
    override func viewDidLoad() {
        super.viewDidLoad()
        setSpeakersAsDefaultAudioOutput()
        loadVoices()
        loadKeyboard()
        loadHeader()
        loadButton()
        loadAISwitch()
        loadInstrumentSelector()
        loadOctaveStepper()
    }
    
    func loadHeader() {
        let headerText = UITextView(frame: CGRect(x: 100, y: 48, width: 380, height: 70))
        headerText.text = "New Recording"
        headerText.isEditable = false
        headerText.textColor = .white
        headerText.backgroundColor = .clear
        headerText.textAlignment = .center
        headerText.font = UIFont.systemFont(ofSize: 28)
        headerText.center.x = self.view.center.x
        self.view.addSubview(headerText)
    }
    
    func loadButton() {
        let button = UIButton(frame: CGRect(x: 100, y: 350, width: 110, height: 110))
        button.backgroundColor = .red
        button.setTitle("Record", for: .normal)
        button.layer.cornerRadius = 55
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.center.x = self.view.center.x
        button.center.y = self.view.center.y - 86
        self.view.addSubview(button)
    }
    
    func loadAISwitch() {
        let aiTitle = UITextView(frame: CGRect(x: 20, y: 130, width: 120, height: 50))
        aiTitle.text = "AI Companion"
        aiTitle.isEditable = false
        aiTitle.textColor = .white
        aiTitle.backgroundColor = .clear
        aiTitle.textAlignment = .center
        aiTitle.font = UIFont.systemFont(ofSize: 14)
        aiTitle.center.x = self.view.center.x
        self.view.addSubview(aiTitle)
        
        let aiSwitch = UISwitch(frame: CGRect(x: 200, y: 175, width: 100, height: 50))
        aiSwitch.isOn = self.aiToPlay
        aiSwitch.tintColor = .white
        aiSwitch.addTarget(self, action: #selector(aiSwitchIsChanged), for: .touchUpInside)
        aiSwitch.center.x = self.view.center.x
        self.view.addSubview(aiSwitch)
    }
    
    func loadInstrumentSelector() {
        let instTitle = UITextView(frame: CGRect(x: 20, y: 130, width: 160, height: 50))
        instTitle.text = "Instrument"
        instTitle.isEditable = false
        instTitle.textColor = .white
        instTitle.backgroundColor = .clear
        instTitle.textAlignment = .center
        instTitle.font = UIFont.systemFont(ofSize: 14)
        instTitle.center.x = self.view.center.x - 120
        self.view.addSubview(instTitle)
        
        let instSelector = UIPickerView(frame: CGRect(x: 20, y: 150, width: 160, height: 80))
        instSelector.delegate = self as UIPickerViewDelegate
        instSelector.dataSource = self as UIPickerViewDataSource
        instSelector.backgroundColor = .clear
        instSelector.center.x = self.view.center.x - 120
        self.view.addSubview(instSelector)
    }
    
    func loadOctaveStepper() {
        let octaveTitle = UITextView(frame: CGRect(x: 20, y: 130, width: 160, height: 50))
        octaveTitle.isEditable = false
        octaveTitle.text = "Octave"
        octaveTitle.textColor = .white
        octaveTitle.backgroundColor = .clear
        octaveTitle.textAlignment = .center
        octaveTitle.font = UIFont.systemFont(ofSize: 14)
        octaveTitle.center.x = self.view.center.x + 120
        self.view.addSubview(octaveTitle)
        
        let octaveStepper = UIStepper(frame: CGRect(x: 20, y: 175, width: 160, height: 80))
        octaveStepper.center.x = self.view.center.x + 120
        octaveStepper.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        octaveStepper.layer.cornerRadius = 10
        octaveStepper.maximumValue = 5
        octaveStepper.minimumValue = 1
        octaveStepper.value = Double(synth.octave)
        octaveStepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        self.view.addSubview(octaveStepper)
    }
    
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Enter details", message: "Enter a name for your recording", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            //getting the input values from user
            let name = alertController.textFields?[0].text
            self.processRecording(title: name!)
            self.notesRecorded.removeAll()
            self.showAlertDialog(title: "Recording Saved", message: "Your recording has been saved!")
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in self.notesRecorded.removeAll() }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
            textField.addTarget(alertController, action: #selector(alertController.isNameValid), for: .allEditingEvents)
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertDialog(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .default) { (_) in }
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
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
                showInputDialog()
            }
        }
    }
    
    @objc func aiSwitchIsChanged(aiSwitch: UISwitch) {
        if aiSwitch.isOn {
            self.aiToPlay = true
            self.notesInputted.removeAll()
        } else {
            self.aiToPlay = false
            self.notesInputted.removeAll()
            // stop ai
        }
    }
    
    @objc func stepperChanged(sender: UIStepper!) {
        print("Octave stepper changed: Value is \(sender.value)")
        synth.octave = Int(sender!.value)
    }
    
    func processRecording(title: String) {
        print("Recorded Notes are:")
        print(notesRecorded)
        recordingPersistence.addRecording(Recording(title: title, notes: notesRecorded, instrument: self.patch, octave: synth.octave))
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
            noteVal: note.toBaseNote8(),
            noteOn: true,
            timeOffset: now.toMillis()! - firstNoteTime))
        
        if isRecording {
            recordStartedDuringHumanInteraction = true
            self.notesRecorded.append(NoteEvent(
                noteVal: note.toBaseNote8(),
                noteOn: true,
                timeOffset: now.toMillis()! - timeRecordIsHit))
        }
        
        print("Note on: \(note)")
        synth.playNoteOn(channel: 0, note: note.toBaseNote8(), midiVelocity: 127)
        
        print(now.toMillis()! - firstNoteTime)
        self.notesPressed.insert(note)
        self.workItem?.cancel()
        
    }
    
    func noteOff(note: MIDINoteNumber) { // note is a UInt8
        let now = Date()
        self.notesInputted.append(NoteEvent(
            noteVal: note.toBaseNote8(),
            noteOn: false,
            timeOffset: now.toMillis()! - firstNoteTime))
        
        if isRecording {
            self.notesRecorded.append(NoteEvent(
                noteVal: note.toBaseNote8(),
                noteOn: false,
                timeOffset: now.toMillis()! - timeRecordIsHit))
        }
        
        print("Note off: \(note)")
        synth.playNoteOff(channel: 0, note: note.toBaseNote32(), midiVelocity: 127)
        self.notesPressed.remove(note)
        print(now.toMillis()! - firstNoteTime) // every value of 1000 is a second
        
        if self.aiToPlay {
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
                                    let melodyResponse = try response.body!
                                        .readJSONDecodable(MelodyResponse.self,
                                                           length: response.body!.readableBytes)
                                    //pass newnotes to distribute, then drop them there
                                    let notes = distributeNotes(
                                        noteSequences: melodyResponse!.notes,
                                        timeOffsetToSubtract: newNotes[newNotes.count - 1].timeOffset,
                                        numberOfNotesToDrop: newNotes.count)
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
                            let midiNote = note.noteVal.toMidiNote()
                            
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
                                    self.synth.playNoteOn(channel: 0, note: note.noteVal, midiVelocity: 127)
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
                                    self.synth.playNoteOff(channel: 0, note: UInt32(note.noteVal), midiVelocity: 127)
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
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

extension UIAlertController {
    @objc func isNameValid() {
        if let name = textFields?[0].text,
            let action = actions.first {
            action.isEnabled = name.count > 0 && name.count <= 30
        }
    }
}

extension KeyboardViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Instruments.allCases.count
    }
}

extension KeyboardViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return Instruments.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Changing instrument to \(Instruments.allCases[row].rawValue)")
        self.patch = Instruments.allCases[row].patch
        loadVoices()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: Instruments.allCases[row].rawValue, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}
