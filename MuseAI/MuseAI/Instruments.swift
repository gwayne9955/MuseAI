//
//  Instruments.swift
//  
//
//  Created by Garrett Wayne on 4/30/20.
//

import Foundation

enum Instruments: String, CaseIterable {
    case piano = "Piano"
    case timpani = "Timpani"
    case beacon = "Beacon"
    case synth = "Synth"
    case palmMute = "Palm Mute"
    case bell = "Bell"
    case lightBell = "Light Bell"
    case xylophone = "Xylophone"
    case churchBell = "Church Bell"
    case organ = "Organ"
    case reverbOrgan = "Reverb Organ"
    case accordian = "Accordian"
    case harmonica = "Harmonica"
    case steelGuitar = "Steel Guitar"
    case electricGuitar = "Electric Guitar"

    var patch: Int {
        switch self {
        case .piano:
            return 0
        case .beacon:
            return 4
        case .synth:
            return 5
        case .palmMute:
            return 7
        case .bell:
            return 8
        case .timpani:
            return 10
        case .lightBell:
            return 11
        case .xylophone:
            return 13
        case .churchBell:
            return 14
        case .organ:
            return 16
        case .reverbOrgan:
            return 19
        case .accordian:
            return 21
        case .harmonica:
            return 22
        case .steelGuitar:
            return 24
        case .electricGuitar:
            return 29
        }
    }
}
