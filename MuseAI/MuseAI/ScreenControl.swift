//
//  ScreenControl.swift
//  MuseAI
//
//  Created by Garrett Wayne on 2/7/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import UIKit

class ScreenControl {
    
    static let screenWidthRatio = UIScreen.main.bounds.width / 736
    static let screenHeightRatio = UIScreen.main.bounds.height / 414
    
    static func manageSize(rect: CGRect) -> CGRect {
        return CGRect(x: rect.origin.x * screenWidthRatio, y: rect.origin.y * screenHeightRatio, width: rect.width * screenWidthRatio, height: rect.height * screenHeightRatio)
    }
    
}
