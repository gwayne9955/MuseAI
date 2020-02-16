//
//  KeyboardViewController.swift
//  MuseAI
//
//  Created by Garrett Wayne on 2/8/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import SwiftUI
import UIKit
//import AudioKit
//import AudioKitUI
import AudioToolbox

struct KeyboardViewBridge: UIViewControllerRepresentable {
//    var controllers: [UIViewController]
    
    func makeUIViewController(context: Context) -> KeyboardViewController {
        let keyboardViewController = KeyboardViewController()
        
        return keyboardViewController
    }
    
    func updateUIViewController(_ keyboardViewController: KeyboardViewController, context: Context) {
//        keyboardViewController.setViewControllers(
//            [controllers[0]], direction: .forward, animated: true)
    }
}



