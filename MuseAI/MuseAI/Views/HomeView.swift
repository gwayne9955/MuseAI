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
    @State private var idForDeletion: IndexSet = IndexSet()
    @State private var showingMessage = false
    @ObservedObject private var homeVM = HomeViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        TabView(selection: $selection){
            
            NavigationView {
                List {
                    ForEach (self.homeVM.recordingCellViewModels) { recordingCellVM in
                        RecordingCell(recordingCellVM: recordingCellVM)
                    }
                    .onDelete { indexSet in
                        self.idForDeletion = indexSet
                        self.showingMessage = true
                    }.alert(isPresented: $showingMessage) {
                    Alert(title: Text("Confirmation"),
                          message: Text("Are you sure you want to delete this recording?"),
                          primaryButton: .default(Text("Yes"), action: {
                            self.homeVM.removeRecordings(atOffsets: self.idForDeletion)
                          }),
                          secondaryButton: .cancel(Text("No")))
                    }
                }
                .navigationBarTitle("My Recordings")
                .navigationBarItems(leading:
                    Button(action: {}, label: {
                        VStack {
                            Image(systemName: "questionmark.circle")
                        }
                    }), trailing:
                    Button(action: {
                        self.viewRouter.currentPage = ViewState.KEYBOARD
                    }, label: {
                        VStack {
                            Image(systemName: "square.and.pencil")
                            Text("New")
                        }
                    })
                ).navigationViewStyle(StackNavigationViewStyle())
            }
            .tabItem {
                VStack {
                    Image(systemName: "folder")
                    Text("My Recordings")
                }
            }
            .tag(0)
            
            NavigationView {
                List {
                    Button(action: {
                        self.showingMessage = true
                    }, label: {
                        Text("Sign Out")
                    }).alert(isPresented: $showingMessage) {
                        Alert(title: Text("Confirmation"),
                              message: Text("Are you sure you want to sign out?"),
                              primaryButton: .default(Text("Yes"), action: {
                                self.homeVM.signOut()
                                self.viewRouter.currentPage = ViewState.START
                              }),
                              secondaryButton: .cancel(Text("No")))
                    }
                }
                .navigationBarTitle("Settings")
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(1)
        }
        //        .environment(\.horizontalSizeClass, .compact)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
