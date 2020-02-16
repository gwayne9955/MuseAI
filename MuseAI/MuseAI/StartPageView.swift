//
//  StartPageView.swift
//  MuseAI
//
//  Created by Garrett Wayne on 2/1/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import SwiftUI

struct StartPageView: View {
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
                    
                    NavigationLink(destination: HomeView()) {
                        Text("Continue as guest")
                            .bold()
                    }
                    .padding(.top, 240.0)
                    .buttonStyle(GradientBackgroundStyle())
                    .navigationBarBackButtonHidden(true)
                }
                
            }
        }
    }
}



struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView()
    }
}
