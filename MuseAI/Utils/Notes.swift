//
//  Notes.swift
//  MuseAI
//
//  Created by Garrett Wayne on 5/16/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import AudioKit

public extension MIDINoteNumber {
    func toBaseNote8() -> MIDINoteNumber {
        return self - 72
    }
    
    func toBaseNote32() -> UInt32 {
        return UInt32(self - 72)
    }
    
    func toMidiNote() -> MIDINoteNumber {
        return self + 72
    }
}
