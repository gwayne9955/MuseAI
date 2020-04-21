//
//  MelodyServerApiImpl.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/20/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation

class MelodyServerApiImpl : MelodyServerApi {
    public init() {}
    
    func finishMelody(melody: MelodyRequest) -> MelodyResponse {
        return MelodyResponse(ticksPerQuarter: 0, tempos: [], notes: [], totalTime: 0.0)
    }
}
