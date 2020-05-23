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
    // register application components
    register { AuthenticationService() }.scope(application)
    register { FirestoreUserRepository() as UserRepository }.scope(application)
    register { FirestoreRecordingRepository() as FirestoreRecordingRepository }.scope(application)
    register { LocalRecordingRepository() as LocalRecordingRepository }.scope(application)
    register { RecordingPersistence() as RecordingPersistence }.scope(application)
  }
}
