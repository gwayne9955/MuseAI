//
//  RecordingPersistence.swift
//  MuseAI
//
//  Created by Garrett Wayne on 5/9/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import Firebase
import Combine
import Resolver

//decides which repository to use based on auth
class RecordingPersistence: BaseRecordingRepository, RecordingRepository, ObservableObject {
    @Injected var authenticationService: AuthenticationService
    @Injected var firestoreRecordingRepository: FirestoreRecordingRepository
    @Injected var localRecordingRepository: LocalRecordingRepository
    
    func addRecording(_ recording: Recording) {
        getRecordingRepository().addRecording(recording)
    }
    
    func removeRecording(_ recording: Recording) {
        getRecordingRepository().removeRecording(recording)
    }
    
    func updateRecording(_ recording: Recording) {
        getRecordingRepository().updateRecording(recording)
    }
 
    func getRecordingRepository() -> RecordingRepository {
        if (authenticationService.user != nil) {
            return self.firestoreRecordingRepository
        }
        return self.localRecordingRepository
    }
}
