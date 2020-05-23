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
            
            VStack(alignment: .center) {
                Text("Welcome To MuseAI!")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                Image("MuseAILogo")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    NavigationLink(destination: CreateAccountView()) {
                        Text("Create Account")
                            .bold()
                    }
                    .buttonStyle(GradientBackgroundStyle())
                    .shadow(radius: 10.0, x: 20, y: 10)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .bold()
                    }
                    .buttonStyle(GradientBackgroundStyle())
                    .shadow(radius: 10.0, x: 20, y: 10)
                }
                .padding(.top, 40.0)
                
                Spacer()
                
                Button(action: {
                    self.startPageVM.authenticationService.signOut()
                    self.viewRouter.currentPage = ViewState.HOME
                }, label: {
                    Text("Continue as guest")
                        .bold()
                })
                    .padding(.bottom, 70.0)
                    .buttonStyle(GradientBackgroundStyle())
                    .shadow(radius: 10.0, x: 20, y: 10)
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(
                Color("background")
                    .edgesIgnoringSafeArea(.all))
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
