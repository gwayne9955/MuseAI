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
    @EnvironmentObject var viewRouter: ViewRouter
    var recording: Recording
    
    var body: some View {
        ZStack {
            Image("PianoBackground").resizable().edgesIgnoringSafeArea(.top)
            RecordingViewBridge(recording: recording)
            VStack {
                ZStack {
                    HStack {
                        Button(action: {
                            print("Back button clicked")
                            self.viewRouter.currentPage = ViewState.HOME
                        }) {
                            HStack {
                                Image(systemName: "arrow.left")
                                    .aspectRatio(contentMode: .fit)
                                Text("Back")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.leading, 16)
                        .padding(.trailing, 10)
                        
                    }.frame(minWidth: 0, maxWidth: .infinity,
                            minHeight: 0, maxHeight: 40,
                            alignment: .topLeading)
                    
//                    HStack {
//                        Text(recording.title)
//                            .foregroundColor(.white)
//                            .padding(.top, 4)
//                    }
                }
                
//                Text("Created: "
//                    + recording.createdTime!.dateValue()
//                        .description(with: .current))
//                    .foregroundColor(.white)
                Spacer()
            }
            
        }.edgesIgnoringSafeArea(.bottom)
            .statusBar(hidden: true)
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(recording:
            Recording(title: "Test Record Test Record Test",
                      notes: [], instrument: 4,
                      createdTime: Timestamp.init()))
    }
}
