//
//  AINotes.swift
//  MuseAI
//
//  Created by Garrett Wayne on 2/29/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import AudioKit
import AsyncHTTPClient

class AINotes {

    static func getAINotes(notesInputted: [NoteEvent], firstNoteTime: Int64, callback: @escaping (Result<HTTPClient.Response, Error>) -> Void) -> [NoteEvent] {
        print("AI getting \(notesInputted)")
        
        let request: MelodyRequest = MelodyRequest(notes: self.gatherNotes(noteEvents: notesInputted, firstNoteTime: firstNoteTime),
                                                   totalTime: Float(notesInputted[notesInputted.count - 1].timeOffset)/1000.0, tempo: 60.0)
        
        let serverApi = MelodyServerApiImpl()
        serverApi.finishMelody(melody: request, callback: { result in
            switch result {
            case .failure(let error):
                print("Error From AI Server, returning notes entered: " + error.localizedDescription)
                callback(.failure(NetworkError.badRequest))
            case .success(let response):
                if response.status == .ok {
                    callback(.success(response))
                } else {
                    print("Error From AI Server, returning notes entered")
                    callback(.success(response))
                }
            }})
        
        return notesInputted
    }
    
    static func gatherNotes(noteEvents: [NoteEvent], firstNoteTime: Int64) -> [NoteSequence] {
        var lookupStartTimes: [MIDINoteNumber: Int64] = [:]
        var noteSequences: [NoteSequence] = []
        
        for noteEvent in noteEvents {
            if noteEvent.noteOn && lookupStartTimes[noteEvent.noteVal] == nil {
                lookupStartTimes[noteEvent.noteVal] = noteEvent.timeOffset
            }
            else if !noteEvent.noteOn {
                noteSequences.append(NoteSequence(pitch: noteEvent.noteVal, startTime: Float(lookupStartTimes.removeValue(forKey: noteEvent.noteVal) ?? noteEvent.timeOffset)/1000.0, endTime: Float(noteEvent.timeOffset)/1000.0, velocity: velocity))
            }
        }
        
        noteSequences.sort { $0.startTime! < $1.startTime! }
        return noteSequences
    }
}

func distributeNotes(noteSequences: [NoteSequence]) -> [NoteEvent] {
    var noteEvents: [NoteEvent] = []
    
    for noteSequence in noteSequences {
        noteEvents.append(NoteEvent(noteVal: noteSequence.pitch, noteOn: true, timeOffset: Int64((noteSequence.startTime ?? 0.0)*1000)))
        noteEvents.append(NoteEvent(noteVal: noteSequence.pitch, noteOn: false, timeOffset: Int64(noteSequence.endTime*1000)))
    }
    
    noteEvents.sort { $0.timeOffset < $1.timeOffset }
    return noteEvents
}
