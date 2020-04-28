//
//  HomeViewModel.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/27/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import Resolver
import Combine

class HomeViewModel: ObservableObject {
    @Published var welcomeMessage: String = "Welcome to MuseAI!"
    @Injected var authenticationService: AuthenticationService
    
    func signOut() {
        authenticationService.signOut()
    }
    
}
