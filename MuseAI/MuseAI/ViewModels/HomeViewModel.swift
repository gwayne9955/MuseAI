//
//  HomeViewModel.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/27/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import Resolver
import Combine

class HomeViewModel: ObservableObject {
    @Published var welcomeMessage: String = "Welcome to MuseAI!"
    @Injected var authenticationService: AuthenticationService
    @Published var recordingPersistence: RecordingPersistence = Resolver.resolve()
    @Published var recordingCellViewModels = [RecordingCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        recordingPersistence.getRecordingRepository().$recordings.map { recordings in
        recordings.map { recording in
          RecordingCellViewModel(rec: recording)
        }
      }
      .assign(to: \.recordingCellViewModels, on: self)
      .store(in: &cancellables)
    }
    
    func removeRecordings(atOffsets indexSet: IndexSet) {
      // remove from repo
      let viewModels = indexSet.lazy.map { self.recordingCellViewModels[$0] }
      viewModels.forEach { recordingCellViewModel in
        recordingPersistence.removeRecording(recordingCellViewModel.recording)
      }
    }
    
    func addRecording(recording: Recording) {
      recordingPersistence.addRecording(recording)
    }
    
    func signOut() {
        authenticationService.signOut()
    }
    
}
