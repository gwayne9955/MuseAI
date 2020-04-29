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
    
    var body: some View {
        HStack {
            Text(recordingCellVM.recording.title).id(recordingCellVM.id)
            //                onCommit: { //(4)
            //                  if !self.recordingCellVM.recording.title.isEmpty {
            //                    self.onCommit(.success(self.recordingCellVM.recording))
            //                  }
            //                  else {
            //                    self.onCommit(.failure(.empty))
            //                  }
            //        ).id(recordingCellVM.id)
        }
    }
}

enum InputError: Error {
    case empty
}
