//
//  CreateAccountViewModel.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/25/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import Resolver
import Combine

class CreateAccountViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var alertMessage: String = "Error Creating an Account"
    @Injected var authenticationService: AuthenticationService
    @Injected var userRepository: UserRepository
    
    func signUp(callback: @escaping (AuthResult) -> Void) {
        authenticationService.signUp(email: email, password: password) { result in
            switch result {
            case .success( _):
                // store name to DB
                self.userRepository.addUser(self.name)
                callback(.success)
            case .failure(let error):
                self.alertMessage = error.localizedDescription
                callback(.error)
            }
        }
    }
}
