//
//  User.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/28/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AppUser: Codable {
    @DocumentID var id: String?
    var userId: String
    var name: String
}
