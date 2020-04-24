//
//  MelodyServerApi.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/20/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import AudioKit
import AsyncHTTPClient

let velocity = 100

struct NoteSequence: Codable {
    var pitch: MIDINoteNumber
    var startTime: Float?
    var endTime: Float
    var velocity: Int
}

struct MelodyRequest: Codable {
    var notes: [NoteSequence]
    var totalTime: Float
    var tempo: Float
}

struct Tempo: Decodable {
    var qpm: Float
}

struct MelodyResponse: Decodable {
    var ticksPerQuarter: Int
    var tempos: [Tempo]
    var notes: [NoteSequence]
    var totalTime: Float
}

protocol MelodyServerApi {
    func finishMelody(melody: MelodyRequest, callback: @escaping (Result<HTTPClient.Response, Error>) -> Void)
}

public enum NetworkError: Error {
    case badRequest
}
