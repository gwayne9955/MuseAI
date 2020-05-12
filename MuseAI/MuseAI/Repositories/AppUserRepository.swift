//
//  UserRepository.swift
//  MuseAI
//
//  Created by Garrett Wayne on 5/9/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine
import Resolver

class BaseUserRepository {
    @Published var appUser = AppUser(userId: "", name: "")
}

protocol UserRepository: BaseUserRepository {
    func addUser(_ name: String)
    func removeUser(_ user: AppUser)
    func updateUser(_ user: AppUser)
}

class FirestoreUserRepository: BaseUserRepository, UserRepository, ObservableObject {
    var db = Firestore.firestore()
    
    @Injected var authenticationService: AuthenticationService
    let appUsersPath: String = "appUsers"
    var appUserId: String = "unknown"
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
        authenticationService.$user
            .compactMap { user in
                user?.uid
        }
        .assign(to: \.appUserId, on: self)
        .store(in: &cancellables)
        
        // (re)load data if appUser changes
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { user in
                self.loadData()
        }
        .store(in: &cancellables)
    }
    
    private func loadData() {
        db.collection(appUsersPath)
            .whereField("appUserId", isEqualTo: self.appUserId)
            .order(by: "createdTime")
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let queryDocs = querySnapshot.documents.compactMap { document -> AppUser? in
                        try? document.data(as: AppUser.self)
                    }
                    self.appUser = queryDocs.first ?? AppUser(userId: "", name: "")
                }
        }
    }
    
    func addUser(_ name: String) {
        do {
            let appUser = AppUser(userId: self.appUserId, name: name)
            let _ = try db.collection(appUsersPath).addDocument(from: appUser)
        }
        catch {
            fatalError("Unable to encode appUser: \(error.localizedDescription).")
        }
    }
    
    func removeUser(_ user: AppUser) {
        if let appUserID = user.id {
            db.collection(appUsersPath).document(appUserID).delete { (error) in
                if let error = error {
                    print("Unable to remove document: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateUser(_ user: AppUser) {
        if let appUserID = user.id {
            do {
                try db.collection(appUsersPath).document(appUserID).setData(from: user)
            }
            catch {
                fatalError("Unable to encode appUser: \(error.localizedDescription).")
            }
        }
    }
}
