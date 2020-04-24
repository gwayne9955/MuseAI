//
//  MelodyServerApiImpl.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/20/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import AsyncHTTPClient

class MelodyServerApiImpl : MelodyServerApi {
    
    public init() {}
    
    let melodyAIServerURL = "http://35.184.177.160:5000/melody"
    
    func finishMelody(melody: MelodyRequest, callback: @escaping (Result<HTTPClient.Response, Error>) -> Void) {
        
        var request: HTTPClient.Request
        do {
            request = try HTTPClient.Request(url: melodyAIServerURL, method: .POST)
            request.headers.add(name: "User-Agent", value: "Swift HTTPClient")
            request.headers.add(name: "Content-Type", value: "application/json")
            
            // Convert object to JSON as NSData
            let jsonData = try JSONEncoder().encode(melody)

            // Convert NSData to String
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print("JSON string: \(jsonString)")
            
            request.body = .string(jsonString)
            httpClient.execute(request: request).whenComplete(callback)
        } catch {
            callback(.failure(NetworkError.badRequest))
        }
    }
    
    func defaultMelodyResponse(request: MelodyRequest) -> MelodyResponse {
        return MelodyResponse(ticksPerQuarter: 220, tempos: [Tempo(qpm: Float(request.tempo))], notes: request.notes, totalTime: Float(request.totalTime))
    }
}
