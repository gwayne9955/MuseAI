//
//  CreateAccountView.swift
//  MuseAI
//
//  Created by Garrett Wayne on 2/1/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import SwiftUI

struct CreateAccountView: View {
    // MARK: - Propertiers
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    
    // MARK: - View
    var body: some View {
        VStack() {

            Image("MuseAILogo")
                .resizable()
                .frame(width: 150, height: 150)
                .shadow(radius: 10.0, x: 20, y: 10)
                .padding(.top, 50)
            
            Text("Create a MuseAI Account")
            .font(.largeTitle).foregroundColor(Color.white)
            .padding([.top, .bottom], 20)
            .shadow(radius: 10.0, x: 20, y: 10)
            
            VStack(alignment: .leading, spacing: 15) {
                TextField("Name", text: self.$name)
                .padding()
                .background(Color.themeTextField)
                .cornerRadius(20.0)
                .shadow(radius: 10.0, x: 20, y: 10)
                
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
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .buttonStyle(GradientBackgroundStyle())
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding(.top, 50)
            
            Spacer()
            .background(GeometryGetter(rect: $kGuardian.rects[0]))
        }
        .background(
            Color("background")
            .edgesIgnoringSafeArea(.all))
        .offset(y: kGuardian.slide).animation(.easeInOut(duration: 1.0))
        
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
