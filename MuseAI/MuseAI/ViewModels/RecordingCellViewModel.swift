//
//  RecordingCellViewModel.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/28/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import Resolver
import Combine

class RecordingCellViewModel: ObservableObject, Identifiable  {
    @Published var recording: Recording
    @Injected var recordingPersistence: RecordingPersistence
    
    var id: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    static func newRecording() -> RecordingCellViewModel {
        RecordingCellViewModel(rec: Recording(title: "", notes: [], instrument: 0))
    }
    
    init(rec: Recording) {
        self.recording = rec
        
        $recording
            .map { $0.id! }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        
        $recording
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { recording in
                self.recordingPersistence.updateRecording(recording)
        }
        .store(in: &cancellables)
        
    }
}
