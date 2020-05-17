//
//  Recording.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/28/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Recording: Codable {
    var id: String?
    var userId: String?
    var title: String
    var notes: [NoteEvent]
    var instrument: Int
    var octave: Int
    @ServerTimestamp var createdTime: Timestamp?
}

#if DEBUG
let testDataRecordings = [
    Recording(title: "Recording 1", notes: [], instrument: 0, octave: 3),
    Recording(title: "Recording 2", notes: [], instrument: 0, octave: 3),
    Recording(title: "Recording 3", notes: [], instrument: 0, octave: 3)
]
#endif
