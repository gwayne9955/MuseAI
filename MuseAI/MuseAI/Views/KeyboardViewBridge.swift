//
//  KeyboardViewController.swift
//  MuseAI
//
//  Created by Garrett Wayne on 2/8/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import SwiftUI

struct KeyboardViewBridge: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> KeyboardViewController {
        let keyboardViewController = KeyboardViewController()
        
        return keyboardViewController
    }
    
    func updateUIViewController(_ keyboardViewController: KeyboardViewController, context: Context) {
    }
}

struct KeyboardViewBridge_Preview: PreviewProvider {
    static var previews: some View {
        KeyboardViewBridge()
    }
}


