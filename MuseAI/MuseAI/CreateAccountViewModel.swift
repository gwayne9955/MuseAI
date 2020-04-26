//
//  CreateAccountViewModel.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/25/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class CreateAccountViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var alertMessage: String = "Error Creating an Account"
    
    func signup(callback: @escaping (AuthResult) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if result != nil {
                callback(.success)
            }
            else {
                self.alertMessage = error!.localizedDescription
                callback(.error)
            }
        }
    }
    
    enum AuthResult: Error {
        case success
        case error
    }
    
}
