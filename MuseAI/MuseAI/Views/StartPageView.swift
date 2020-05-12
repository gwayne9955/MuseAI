//
//  StartPageView.swift
//  MuseAI
//
//  Created by Garrett Wayne on 2/1/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import SwiftUI

struct StartPageView: View {
    
    @ObservedObject private var startPageVM = StartPageViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center) {
                    Text("Welcome To MuseAI!")
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                    
                    NavigationLink(destination: CreateAccountView()) {
                        Text("Create Account")
                            .bold()
                    }
                    .padding(.top, 160.0)
                    .buttonStyle(GradientBackgroundStyle())
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .bold()
                    }
                    .padding(.top, 20.0)
                    .buttonStyle(GradientBackgroundStyle())
                    
                    Button(action: {
                        self.startPageVM.authenticationService.signOut()
                        self.viewRouter.currentPage = ViewState.HOME
                    }, label: {
                        Text("Continue as guest")
                            .bold()
                    })
                    .padding(.top, 240.0)
                    .buttonStyle(GradientBackgroundStyle())
                }
                
            }
        }
    }
}

extension Color {
    static var themeTextField: Color {
        return Color(red: 220.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, opacity: 1.0)
    }
}

struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView()
    }
}
