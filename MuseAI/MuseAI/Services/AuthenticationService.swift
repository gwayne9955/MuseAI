//
//  AuthenticationService.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/25/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import FirebaseAuth

public enum AuthResult: Error {
    case success
    case error
}

class AuthenticationService: ObservableObject {
    
    @Published var user: User?
    
    //    @LazyInjected private var taskRepository: TaskRepository
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        registerStateListener()
    }
    
    func signUp(email: String, password: String, callback: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if result != nil {
                self.user = result!.user
                callback(.success(result!))
            }
            else {
                callback(.failure(error!))
            }
        }
    }
    
    func signIn(email: String, password: String, callback: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if result != nil {
                self.user = result!.user
                callback(.success(result!))
            }
            else {
                callback(.failure(error!))
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("Error when trying to sign out: \(error.localizedDescription)")
        }
    }
    
    private func registerStateListener() {
        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Sign in state has changed.")
            self.user = user
            
            if let user = user {
                let anonymous = user.isAnonymous ? "anonymously " : ""
                print("User signed in \(anonymous)with user ID \(user.uid).")
            }
            else {
                print("Signed Out User: \(user?.email ?? "(No user)")")
                self.user = nil
            }
        }
    }
}
