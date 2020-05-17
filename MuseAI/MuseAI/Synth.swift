//
//  Synth.swift
//  MuseAI
//
//  Created by Garrett Wayne on 2/7/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import CoreAudio
import AudioKit

final class Synth: Speaker {
    override init() {
        super.init()
        initAudio()
        loadSoundFont()
        loadPatch(patchNo: Instruments.piano.patch)
    }
    
    var octave = 3
    let midiChannel = 0
    let midiVelocity = UInt32(127)
    
    func playNoteOn(channel: Int, note: UInt8, midiVelocity: Int) {
        let noteCommand = UInt32(0x90 | channel) // ON command
        let base = note + 24
        let octaveAdjust = (UInt8(octave) * 12) + base
        let pitch = UInt32(octaveAdjust)
        checkError(osstatus: MusicDeviceMIDIEvent(synthUnit!, noteCommand, pitch, UInt32(midiVelocity), 0))
    }
    
    func playNoteOff(channel: Int, note: UInt32, midiVelocity: Int) {
        let noteCommand = UInt32(0x80 | channel)
        let base = UInt8(note + 24)
        let octaveAdjust = (UInt8(octave) * 12) + base
        let pitch = UInt32(octaveAdjust)
        checkError(osstatus: MusicDeviceMIDIEvent(synthUnit!, noteCommand, pitch, 0, 0))
    }
}
