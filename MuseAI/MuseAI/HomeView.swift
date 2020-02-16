//
//  HomeView.swift
//  MuseAI
//
//  Created by Garrett Wayne on 2/1/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import SwiftUI
import UIKit
import AudioToolbox

struct HomeView: View {
    @State private var selection = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection){
                Text("First View")
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "folder")
                            Text("My Recordings")
                        }
                }
                .tag(0)
                Text("Second View")
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                }
                .tag(1)
            }
            .navigationBarItems(trailing:
                NavigationLink(destination: KeyboardView(), label: {
                    VStack {
                        Image(systemName: "square.and.pencil")
                        Text("New")
                    }
                })
            )
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
