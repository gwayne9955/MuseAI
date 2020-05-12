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
    @ObservedObject private var keyboard = KeyboardResponder()
    @ObservedObject private var createAccountVM = CreateAccountViewModel()
    @State private var showingAlert = false
    @EnvironmentObject var viewRouter: ViewRouter
    
    // MARK: - View
    var body: some View {
        VStack() {
            
            Image("MuseAILogo")
                .resizable()
                .frame(width: 150, height: 150)
                .shadow(radius: 10.0, x: 20, y: 10)
                .padding(.top, 40)
            
            Text("Create a MuseAI Account")
                .font(.largeTitle).foregroundColor(Color.white)
                .padding([.top, .bottom], 10)
                .shadow(radius: 10.0, x: 20, y: 10)
            
            VStack(alignment: .leading, spacing: 15) {
                TextField("Name", text: $createAccountVM.name)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                TextField("Email", text: $createAccountVM.email)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                SecureField("Password", text: $createAccountVM.password)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding([.leading, .trailing], 27.5)
            
            Button(action: {
                if self.createAccountVM.name.count < 1 {
                    self.createAccountVM.alertMessage
                        = "Please enter a name"
                    self.showingAlert = true
                }
                else {
                    self.createAccountVM.signUp { authResult in
                        switch authResult {
                        case .success:
                            print(authResult)
                            self.viewRouter.currentPage = ViewState.HOME
                        case .error:
                            self.showingAlert = true
                        }
                    }
                }
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .buttonStyle(GradientBackgroundStyle())
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding(.top, 20)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error while creating account"), message: Text(createAccountVM.alertMessage), dismissButton: .default(Text("Got it!")))
            }
            
            Spacer()
        }
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut(duration: 0.16))
        .background(
            Color("background")
                .edgesIgnoringSafeArea(.all))
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
