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
        var rec = recording
        if rec.id == nil {
            rec.id = AutoId.newId()
        }
        
        rec.createdTime = Timestamp.init()
        
        self.recordings.append(rec)
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

class FirestoreRecordingRepository: BaseRecordingRepository, RecordingRepository, ObservableObject {
    var db = Firestore.firestore()
    
    @Injected var authenticationService: AuthenticationService
    let recordingsPath: String = "recordings"
    var userId: String = "unknown"
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
        authenticationService.$user
            .compactMap { user in
                user?.uid
        }
        .assign(to: \.userId, on: self)
        .store(in: &cancellables)
        
        // (re)load data if user changes
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { user in
                self.loadData()
        }
        .store(in: &cancellables)
    }
    
    private func loadData() {
        db.collection(recordingsPath)
            .whereField("userId", isEqualTo: self.userId)
            .order(by: "createdTime")
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.recordings = querySnapshot.documents.compactMap { document -> Recording? in
                        var r = try? document.data(as: Recording.self)
                        r!.id = document.documentID
                        return r
                    }
                }
        }
    }
    
    func addRecording(_ recording: Recording) {
        do {
            var userRecording = recording
            userRecording.userId = self.userId
            let _ = try db.collection(recordingsPath).addDocument(from: userRecording)
        }
        catch {
            fatalError("Unable to encode recording: \(error.localizedDescription).")
        }
    }
    
    func removeRecording(_ recording: Recording) {
        if let recordingID = recording.id {
            db.collection(recordingsPath).document(recordingID).delete { (error) in
                if let error = error {
                    print("Unable to remove document: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateRecording(_ recording: Recording) {
        if let recordingID = recording.id {
            do {
                try db.collection(recordingsPath).document(recordingID).setData(from: recording)
            }
            catch {
                fatalError("Unable to encode recording: \(error.localizedDescription).")
            }
        }
    }
}
