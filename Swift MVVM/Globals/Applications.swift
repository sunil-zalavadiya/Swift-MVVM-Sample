//
//  Applications.swift
//  Swift MVVM
//
//  Created by Kartum on 28/08/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import Foundation
import UIKit

/// Application
struct Application {
    
    /// Debug Log enable or not
    static let debug: Bool = true
    
    /// Application Mode
    static let mode = Mode.sendbox
    
    /// Application in production or sendbox
    enum Mode {
        case sendbox
        case production
    }
    
    /// App Color
    struct Color {
        static let APP_THEME_COLOR  = #colorLiteral(red: 0.3333333333, green: 0.7882352941, blue: 0.631372549, alpha: 1)     // #55c9a1
        static let FONT_COLOR       = #colorLiteral(red: 0.6, green: 0.5607843137, blue: 0.6352941176, alpha: 1)
        static let FONT_BLACK_COLOR = #colorLiteral(red: 0.1411764706, green: 0.07450980392, blue: 0.1960784314, alpha: 1)
    }
    
    /// App Fonts
    struct Font {
        static let  regular            =   "Montserrat-Regular"
        static let  medium             =   "Montserrat-Medium"
        static let  bold               =   "Montserrat-Bold"
        static let  semiBold           =   "Montserrat-SemiBold"
    }
    
    struct API {
        static let BASE_URL = ""
    }
    
    struct Device {
        static let version = UIDevice.current.systemVersion
    }
}
