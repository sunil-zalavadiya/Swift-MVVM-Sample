//
//  IndicatorManager.swift
//  Swift MVVM
//
//  Created by Kartum on 28/08/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import Foundation
import MBProgressHUD

class IndicatorManager: NSObject {
    
    private static var loadingCount = 0
    
    class func showLoader() {
        
        if loadingCount == 0 {
            // Show loader
            DispatchQueue.main.async {
                _ = MBProgressHUD.showAdded(to: AppDelegate.shared.window!, animated: true)
            }
        }
        loadingCount += 1
        
    }
    
    class func hideLoader() {
        
        if loadingCount > 0 {
            loadingCount -= 1
        }
        if loadingCount == 0 {
            // Hide loader
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: AppDelegate.shared.window!, animated: true)
            }
        }
        
    }
}
