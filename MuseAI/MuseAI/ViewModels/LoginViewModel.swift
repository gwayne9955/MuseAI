//
//  LoginViewModel.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/27/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import Resolver
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var alertMessage: String = "Error Signing In"
    @Injected var authenticationService: AuthenticationService
    
    func signIn(callback: @escaping (AuthResult) -> Void) {
        if authenticationService.user != nil {
            callback(.success)
        }
        authenticationService.signIn(email: email, password: password) { result in
            switch result {
            case .success( _):
                callback(.success)
            case .failure(let error):
                self.alertMessage = error.localizedDescription
                callback(.error)
            }
        }
    }
    
    func checkAuthStatus() -> AuthResult {
        if authenticationService.user != nil {
            return .success
        }
        return .error
    }
}
