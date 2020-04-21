//
//  MelodyServerApi.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/20/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import AudioKit

let velocity = 100

struct NoteSequence {
    var pitch: MIDINoteNumber
    var startTime: Float
    var endTime: Float
    var velocity: Int
}

struct MelodyRequest {
    var notes: [NoteSequence]
    var totalTime: Int64
    var tempo: Int
}

struct Tempo {
    var qpm: Float
}

struct MelodyResponse {
    var ticksPerQuarter: Int
    var tempos: [Tempo]
    var notes: [NoteSequence]
    var totalTime: Float
}

protocol MelodyServerApi {
    func finishMelody(melody: MelodyRequest) -> MelodyResponse
}
