//
//  RecordingViewModel.swift
//  MuseAI
//
//  Created by Garrett Wayne on 5/11/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation

import Resolver
import Combine

class RecordingViewModel: ObservableObject {
    @Published var alertMessage: String = "Error Creating an Account"
    @Published var recordingPersistence: RecordingPersistence = Resolver.resolve()
    
    
}
