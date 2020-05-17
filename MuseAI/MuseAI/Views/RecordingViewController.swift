//
//  RecordingViewController.swift
//  MuseAI
//
//  Created by Garrett Wayne on 5/12/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import UIKit
import AudioKit
import AudioKitUI
import AudioToolbox
import AsyncHTTPClient
import Resolver
import FirebaseFirestore

class RecordingViewController: UIViewController {
    
    @Injected var recordingPersistence: RecordingPersistence
    let synth = Synth()
    var aKKeyboardView: AKKeyboardView?
    var notesPressed = Set<MIDINoteNumber>()
    var firstNoteTime: Int64 = 0
    var recording: Recording = Recording(title: "Test Title", notes: [], instrument: 0, octave: 3, createdTime: Timestamp.init())
    var textTitle = UITextView(frame: CGRect(x: 10, y: 50, width: 400, height: 90))
    
    //This function loads the view controller (window through which users view app elements)
    override func viewDidLoad() {
        super.viewDidLoad()
        setSpeakersAsDefaultAudioOutput()
        loadVoices()
        loadKeyboard()
        loadText()
        loadButton() // for playing the recording
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
            self.showAlertDialog(title: "Recording Saved", message: "Your recording has been saved!")
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in  }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
            textField.text = self.recording.title
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
        print("Play Button tapped")
        synth.octave = recording.octave
        var workers: [NoteWorker] = []
        let dispatchTime = DispatchTime.now()
        for noteEvent in recording.notes {
            
            let offset: Double = Double(noteEvent.timeOffset) / 1000.0
            let midiNote = noteEvent.noteVal.toMidiNote()
            
            if noteEvent.noteOn {
                workers.append(NoteWorker(offset: offset, worker: DispatchWorkItem {
                    print("Note on: \(midiNote)")
                    self.aKKeyboardView?.programmaticNoteOn(midiNote)
                    self.synth.playNoteOn(channel: 0, note: noteEvent.noteVal, midiVelocity: 127)
                }))
            }
            else {
                workers.append(NoteWorker(offset: offset, worker: DispatchWorkItem {
                    print("Note off: \(midiNote)")
                    self.aKKeyboardView?.programmaticNoteOff(midiNote)
                    self.synth.playNoteOff(channel: 0, note: UInt32(noteEvent.noteVal), midiVelocity: 127)
                }))
            }
        }
        
        for w in workers {
            DispatchQueue.main.asyncAfter(deadline: dispatchTime + w.offset, execute: w.worker)
        }
    }
    
    @objc func buttonAction2(sender: UIButton!) {
        print("Edit Button tapped")
        showInputDialog()
    }
    
    func processRecording(title: String) {
        self.recording.title = title
        self.textTitle.text = title
        recordingPersistence.updateRecording(self.recording)
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
        aKKeyboardView!.isUserInteractionEnabled = false
        aKKeyboardView!.polyphonicMode = true
    }

    func loadVoices() {
        DispatchQueue.global(qos: .background).async {
            self.synth.loadPatch(patchNo: self.recording.instrument)
        }
    }
    
    func loadText() {
        textTitle.isEditable = false
        textTitle.text = self.recording.title
        textTitle.textColor = .white
        textTitle.backgroundColor = .clear
        textTitle.font = UIFont.systemFont(ofSize: 28)
        self.view.addSubview(textTitle)
        
        let createdTitle = UITextView(frame: CGRect(x: 10, y: 86, width: 400, height: 90))
        createdTitle.isEditable = false
        let createdTime = self.recording.createdTime!.dateValue().description(with: .current)
        if createdTime.contains("AM") {
            if let range = createdTime.range(of: "AM") {
                let substring = createdTime[..<range.lowerBound]
                createdTitle.text = "Created: " + substring + "AM"
            }
            else {
              createdTitle.text = "Created: " + createdTime
            }
        }
        else {
            if let range = createdTime.range(of: "PM") {
                let substring = createdTime[..<range.lowerBound]
                createdTitle.text = "Created: " + substring + "PM"
            }
            else {
              createdTitle.text = "Created: " + createdTime
            }
        }
        createdTitle.textColor = .white
        createdTitle.backgroundColor = .clear
        createdTitle.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(createdTitle)
    }
    
    func loadButton() {
        let button = UIButton(frame: CGRect(x: 100, y: 150, width: 100, height: 50))
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.setTitle("Play", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.center.x = self.view.center.x + 56
        self.view.addSubview(button)
        
        let button2 = UIButton(frame: CGRect(x: 200, y: 150, width: 100, height: 50))
        button2.backgroundColor = .gray
        button2.layer.cornerRadius = 5
        button2.layer.borderWidth = 1
        button2.setTitle("Edit", for: .normal)
        button2.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
        button.center.x = self.view.center.x - 56
        self.view.addSubview(button2)
    }
}

extension RecordingViewController: AKKeyboardDelegate {

    func noteOn(note: MIDINoteNumber) {}

    func noteOff(note: MIDINoteNumber) {}
}

