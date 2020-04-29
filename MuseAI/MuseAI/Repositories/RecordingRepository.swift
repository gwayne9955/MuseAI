//
//  RecordingRepository.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/28/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import Disk

import Firebase
import FirebaseFirestore

import Combine
import Resolver


class BaseRecordingRepository {
    @Published var recordings = [Recording]()
}

protocol RecordingRepository: BaseRecordingRepository {
    func addRecording(_ recording: Recording)
    func removeRecording(_ recording: Recording)
    func updateRecording(_ recording: Recording)
}

class TestDataRecordingRepository: BaseRecordingRepository, RecordingRepository, ObservableObject {
    override init() {
        super.init()
        self.recordings = testDataRecordings
    }
    
    func addRecording(_ recording: Recording) {
        recordings.append(recording)
    }
    
    func removeRecording(_ recording: Recording) {
        if let index = recordings.firstIndex(where: { $0.id == recording.id }) {
            recordings.remove(at: index)
        }
    }
    
    func updateRecording(_ recording: Recording) {
        if let index = self.recordings.firstIndex(where: { $0.id == recording.id } ) {
            self.recordings[index] = recording
        }
    }
}

class LocalRecordingRepository: BaseRecordingRepository, RecordingRepository, ObservableObject {
  override init() {
    super.init()
    loadData()
  }
  
  func addRecording(_ recording: Recording) {
    self.recordings.append(recording)
    saveData()
  }
  
  func removeRecording(_ recording: Recording) {
    if let index = recordings.firstIndex(where: { $0.id == recording.id }) {
      recordings.remove(at: index)
      saveData()
    }
  }
  
  func updateRecording(_ recording: Recording) {
    if let index = self.recordings.firstIndex(where: { $0.id == recording.id } ) {
      self.recordings[index] = recording
      saveData()
    }
  }
  
  private func loadData() {
    if let retrievedRecordings = try? Disk.retrieve("recordings.json", from: .documents, as: [Recording].self) { // (1)
      self.recordings = retrievedRecordings
    }
  }
  
  private func saveData() {
    do {
      try Disk.save(self.recordings, to: .documents, as: "recordings.json") // (2)
    }
    catch let error as NSError {
      fatalError("""
        Domain: \(error.domain)
        Code: \(error.code)
        Description: \(error.localizedDescription)
        Failure Reason: \(error.localizedFailureReason ?? "")
        Suggestions: \(error.localizedRecoverySuggestion ?? "")
        """)
    }
  }
}
