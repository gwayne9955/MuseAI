//
//  RecordingCell.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/28/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import Resolver
import Combine
import SwiftUI

struct RecordingCell: View {
    @ObservedObject var recordingCellVM: RecordingCellViewModel
    var onCommit: (Result<Recording, InputError>) -> Void = { _ in }
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        HStack {
            Button(action: {
                self.viewRouter.recording = self.recordingCellVM.recording
                self.viewRouter.currentPage = ViewState.RECORDING
            }, label: {
                HStack {
                    Text(recordingCellVM.recording.title)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            })
        }
    }
}

enum InputError: Error {
    case empty
}
