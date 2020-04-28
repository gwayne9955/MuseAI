//
//  ViewRouter.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/27/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

public enum ViewState {
    case START
    case CREATE_ACCOUNT
    case LOGIN
    case HOME
    case KEYBOARD
}

class ViewRouter: ObservableObject {
    
    let objectWillChange = PassthroughSubject<ViewRouter,Never>()
    
    var currentPage: ViewState = ViewState.START {
        didSet {
            withAnimation() {
                objectWillChange.send(self)
            }
        }
    }
}
