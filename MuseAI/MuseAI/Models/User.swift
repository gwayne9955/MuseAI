//
//  User.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/28/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation

struct AppUser: Codable {
    var userId: String
    var name: String
    var recordings: [Recording]
}
