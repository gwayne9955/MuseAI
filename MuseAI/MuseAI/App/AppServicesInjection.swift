//
//  AppServicesInjection.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/27/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import Resolver
import FirebaseFirestore

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    // register Firebase services
//    register { Firestore.firestore().useEmulator() }.scope(application)
    
    // register application components
    register { AuthenticationService() }.scope(application)
//    register { TestDataRecordingRepository() as RecordingRepository }.scope(application)
    register { LocalRecordingRepository() as RecordingRepository }.scope(application)
//    register { FirestoreRecordingRepository() as RecordingRepository }.scope(application)
  }
}
