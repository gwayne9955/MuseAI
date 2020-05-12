//
//  RecordingView.swift
//  MuseAI
//
//  Created by Garrett Wayne on 5/11/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RecordingView: View {
    let recording: Recording
    
    var body: some View {
        HStack {
            VStack {
                Text("Recording: " + recording.title)
                Text("created: " + recording.createdTime!.dateValue().description(with: .current))
            }
        }
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(recording: Recording(title: "Test Recording", notes: [], instrument: 4, createdTime: Timestamp.init()))
    }
}
