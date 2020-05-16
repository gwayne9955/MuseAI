//
//  KeyboardView.swift
//  MuseAI
//
//  Created by Garrett Wayne on 2/8/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import SwiftUI

struct KeyboardView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack {
            Image("PianoBackground").resizable().edgesIgnoringSafeArea(.top)
            KeyboardViewBridge()
            Button(action: {
                self.viewRouter.currentPage = ViewState.HOME
            }) {
                HStack {
                    Image(systemName: "arrow.left")
                    .aspectRatio(contentMode: .fit)
                    Text("Back")
                        .foregroundColor(.white)
                }
            }.position(x: 60.0, y: 20.0)
        }.edgesIgnoringSafeArea(.bottom)
        .statusBar(hidden: true)
    }
}

struct KeyboardView_Preview: PreviewProvider {
    static var previews: some View {
        KeyboardView()
    }
}


