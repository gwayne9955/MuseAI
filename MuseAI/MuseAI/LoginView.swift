//
//  LoginView.swift
//  MuseAI
//
//  Created by Garrett Wayne on 2/1/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    // MARK: - Propertiers
    @State private var email = ""
    @State private var password = ""
    
    // MARK: - View
    var body: some View {
        VStack() {

            Image("MuseAILogo")
                .resizable()
                .frame(width: 150, height: 150)
                .shadow(radius: 10.0, x: 20, y: 10)
                .padding(.top, 50)
            
            Text("Sign In")
            .font(.largeTitle).foregroundColor(Color.white)
            .padding([.top, .bottom], 20)
            .shadow(radius: 10.0, x: 20, y: 10)
            
            VStack(alignment: .leading, spacing: 15) {
                TextField("Email", text: self.$email)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                SecureField("Password", text: self.$password)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding([.leading, .trailing], 27.5)
            
            Button(action: {}) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .buttonStyle(GradientBackgroundStyle())
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding(.top, 50)
            
            Spacer()
            HStack(spacing: 0) {
                Text("Don't have an account? ")
                    .foregroundColor(.white)
                Button(action: {}) {
                    Text("Sign Up")
                        .foregroundColor(Color("DarkBlue"))
                }
            }
        }
        .background(
            Color("background")
            .edgesIgnoringSafeArea(.all))
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
