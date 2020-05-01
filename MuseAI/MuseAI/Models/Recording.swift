//
//  Recording.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/28/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation

struct Recording: Codable {
    var id: String = UUID().uuidString
    var userId: String = ""
    var title: String
    var notes: [NoteEvent]
    var instrument: Int = 0
}

#if DEBUG
let testDataRecordings = [
    Recording(title: "Recording 1", notes: []),
    Recording(title: "Recording 2", notes: []),
    Recording(title: "Recording 3", notes: [])
]
#endif
