//
//  AutoId.swift
//  MuseAI
//
//  Created by Garrett Wayne on 5/9/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation

class AutoId {
    
    static func newId() -> String {
        // Alphanumeric characters
        let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        var autoId = ""
        for _ in 0...20 {
            autoId += chars[Int(arc4random_uniform(UInt32(chars.count)))]
        }
        return autoId;
    }
}

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
