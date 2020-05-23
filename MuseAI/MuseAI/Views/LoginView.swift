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
    @ObservedObject private var keyboard = KeyboardResponder()
    @ObservedObject private var loginVM = LoginViewModel()
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
            
            Text("Sign In")
                .font(.largeTitle).foregroundColor(Color.white)
                .padding([.top, .bottom], 10)
                .shadow(radius: 10.0, x: 20, y: 10)
            
            VStack(alignment: .leading, spacing: 15) {
                TextField("Email", text: self.$loginVM.email)
                    .autocapitalization(.none)
                    .padding()
                    .keyboardType(.emailAddress)
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                SecureField("Password", text: self.$loginVM.password)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding([.leading, .trailing], 27.5)
            
            Button(action: {
                self.loginVM.signIn { authResult in
                    switch authResult {
                    case .success:
                        self.viewRouter.currentPage = ViewState.HOME
                    case .error:
                        self.showingAlert = true
                    }
                }
            }) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .shadow(radius: 10.0, x: 20, y: 10)
            .frame(width: 200, height: 60)
            .buttonStyle(GradientBackgroundStyle())
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error while signing in"), message: Text(loginVM.alertMessage), dismissButton: .default(Text("Try again")))
            }
            
            Spacer()
            HStack(spacing: 10) {
                Text("Don't have an account? ")
                    .foregroundColor(.white)
                NavigationLink(destination: CreateAccountView(), label: {
                    Text("Sign Up")
                        .foregroundColor(Color(UIColor.systemBlue))
                })
            }.padding(.bottom, 40)
        }
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut(duration: 0.16))
        .background(Color("background")
        .edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
            switch self.loginVM.checkAuthStatus() {
            case .success:
                self.viewRouter.currentPage = ViewState.HOME
            case .error:
                break
            }
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
