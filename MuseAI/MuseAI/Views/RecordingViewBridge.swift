//
//  RecordingViewBridge.swift
//  MuseAI
//
//  Created by Garrett Wayne on 5/12/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RecordingViewBridge: UIViewControllerRepresentable {
    var recording: Recording
    
    func makeUIViewController(context: Context) -> RecordingViewController {
        let recordingViewController = RecordingViewController()
        recordingViewController.recording = recording
        
        return recordingViewController
    }
    
    func updateUIViewController(_ recordingViewController: RecordingViewController, context: Context) {
    }
}

struct RecordingViewBridge_Preview: PreviewProvider {
    static var previews: some View {
        RecordingViewBridge(recording: Recording(title: "Test Title", notes: [], instrument: 0, createdTime: Timestamp.init()))
    }
}
