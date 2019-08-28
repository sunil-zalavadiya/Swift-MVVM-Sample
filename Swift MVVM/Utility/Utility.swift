//
//  Utility.swift
//  SerwizConsumer
//
//  Created by Sunil Zalavadiya on 19/03/19.
//  Copyright © 2019 Sunil Zalavadiya. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import UserNotifications

class Utility {
    
    // MARK: - Variables
    static let shared = Utility()
    
    var enableLog = true
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var loaderCount = 0
    var currentLocation = CLLocationCoordinate2D()

    var timeStampInterval: TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    var timeStampString: String {
        return "\(Date().timeIntervalSince1970)"
    }
    
    // MARK: - Functions
    class func isLogEnable() -> Bool {
        return self.shared.enableLog
    }
    
    class func enableLog() {
        self.shared.enableLog = true
    }
    
    class func disableLog() {
        self.shared.enableLog = false
    }
    
    class func appDelegate() -> AppDelegate {
        return self.shared.appDelegate
    }
    
    class func windowMain() -> UIWindow? {
        return self.appDelegate().window
    }
    
    class func rootViewControllerMain() -> UIViewController? {
        return self.windowMain()?.rootViewController
    }
    
    class func applicationMain() -> UIApplication {
        return UIApplication.shared
    }
    
    class func getMajorSystemVersion() -> Int {
        let systemVersionStr = UIDevice.current.systemVersion   //Returns 7.1.1
        let mainSystemVersion = Int((systemVersionStr.split(separator: "."))[0])
        
        return mainSystemVersion!
    }
    
    class func getAppUniqueId() -> String {
        let uniqueId: UUID = UIDevice.current.identifierForVendor! as UUID
        
        return uniqueId.uuidString
    }
    
    class func isLocationServiceEnable() -> Bool {
        var locationOn:Bool = false
        
        if CLLocationManager.locationServicesEnabled() {
            
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
                locationOn = true
            } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
                locationOn = true
            }
        } else {
            locationOn = false
        }
        
        return locationOn
    }
    
    class func showAlertForAppSettings(title: String, message: String, completion: @escaping (Bool) -> ()) {
        let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        
        let alertController: UIAlertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default, handler: { (_) -> Void in
            
            alertWindow.isHidden = true
            
            let settingURL = URL(string: UIApplication.openSettingsURLString)!
            
            UIApplication.shared.open(settingURL, options: [:], completionHandler: { (success) in
                DLog(success)
            })
            
            completion(true)
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (_) -> Void in
            
            alertWindow.isHidden = true
            completion(false)
        }))
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func askPermissionFormLocation() {
        let alertController = UIAlertController(title: "We Can't Get Your Location", message: "Turn on location services on your device.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if #available(iOS 10.0, *) {
                    self.applicationMain().open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    self.applicationMain().openURL(url)
                }
            }
        }
        alertController.addAction(openAction)
        
        self.rootViewControllerMain()?.present(alertController, animated: true, completion: nil)
    }
    class func setLocation(_ location:CLLocationCoordinate2D) {
        self.shared.currentLocation = location
        
    }
    class func getLocation() -> CLLocationCoordinate2D {
        return self.shared.currentLocation
        
    }
    class func getJsonObject(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let error {
            DLog("Error!! = \(error)")
        }
        
        return nil
    }
    
    class func jsonStringFromDictionaryOrArrayObject(_ obj: Any) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: obj, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            return jsonString
        } catch let error as NSError {
            print("Error!! = \(error)")
        }
        
        return ""
    }
    
    class func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
    
    class func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    class func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    class func stringFromTimeInterval(interval: TimeInterval) -> String {
        let time = Int(interval)
        
        let ms: Int = Int(fmod(interval, 1) * 1000)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
    }
    
    class func timeAgoSinceDate(_ date: Date, currentDate: Date, numericDates: Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if components.year! >= 2 {
            return "\(components.year!) years ago"
        } else if components.year! >= 1 {
            if numericDates {
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if components.month! >= 2 {
            return "\(components.month!) months ago"
        } else if components.month! >= 1 {
            if numericDates {
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if components.day! >= 2 {
            return "\(components.day!) days ago"
        } else if components.day! >= 1 {
            if numericDates {
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if components.hour! >= 2 {
            return "\(components.hour!) hours ago"
        } else if components.hour! >= 1 {
            if numericDates {
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if components.minute! >= 2 {
            return "\(components.minute!) minutes ago"
        } else if components.minute! >= 1 {
            if numericDates {
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if components.second! >= 3 {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    class func showMessageAlert(title: String, andMessage message: String, withOkButtonTitle okButtonTitle: String) {
        let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: { (_) -> Void in
            
            alertWindow.isHidden = true
        }))
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func getConstraintForIdentifier(identifier: String, fromView: AnyObject) -> NSLayoutConstraint? {
        for subview in fromView.subviews as [UIView] {
            for constraint in subview.constraints as [NSLayoutConstraint] where constraint.identifier == identifier {
                return constraint
            }
        }
        return nil
    }
    
    class func formatNumberStringToShortForm(numberStr: String) -> String {
        var numberStr = numberStr
        numberStr = numberStr.replacingOccurrences(of: ",", with: "")
        
        if let numberDouble = Double(numberStr) {
            var shortNumber = numberDouble
            var suffixStr = ""
            
            if numberDouble >= 1000000000.0 {
                suffixStr = "Arab"
                shortNumber = numberDouble / 1000000000.0
            } else if numberDouble >= 10000000.0 {
                suffixStr = "Cr"
                shortNumber = numberDouble / 10000000.0
            } else if numberDouble >= 100000.0 {
                suffixStr = "Lac"
                shortNumber = numberDouble / 100000.0
            } else if numberDouble >= 1000.0 {
                suffixStr = "K"
                shortNumber = numberDouble / 1000.0
            }
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let numberAsString = numberFormatter.string(from: NSNumber(value: shortNumber as Double))
            let finalString = String(format: "%@ %@", numberAsString!, suffixStr)
            
            return finalString
        }
        
        return numberStr
    }
    
    class func getStringSplitArray(str: String, separator: Character) -> String {
        let arr = str.split(separator: separator)
        let strName: String = String(arr[arr.count - 1])
        
        return strName
    }
}

/*func getLocalizedString(key: String) -> String {
    
    let languageCode = AppPrefsManager.shared.getLanguageCode()
    
    if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") {
        let bundle = Bundle(path: path)
        
        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    return NSLocalizedString(key, comment: "")
}*/

extension UILabel {
    public func stringForIphone_5(size: CGFloat) {
        if DeviceType.IS_IPHONE_5 {
            self.font = self.font.withSize(size)
        }
    }
}

extension Float {
    var setPrice: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

// MARK: - All UIApplication extensions
extension UIApplication {
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"), self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}

// MARK: - All NSDecimalNumber extensions
extension NSDecimalNumber {
    func toNegative() -> NSDecimalNumber {
        return self.multiplying(by: NSDecimalNumber(mantissa: 1, exponent: 0, isNegative: true))
    }
}

// MARK: - Structs
struct IOS_VERSION {
    static var IS_IOS7 = Utility.getMajorSystemVersion() >= 7 && Utility.getMajorSystemVersion() < 8
    static var IS_IOS8 = Utility.getMajorSystemVersion() >= 8 && Utility.getMajorSystemVersion() < 9
    static var IS_IOS9 = Utility.getMajorSystemVersion() >= 9
}

struct ScreenSize {
    static let SCREEN_BOUNDS = UIScreen.main.bounds
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 1125.0
    static let IS_IPHONE_LESS_THAN_6 =  IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH < 667.0
    static let IS_IPHONE_LESS_THAN_OR_EQUAL_6 =  IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH <= 667.0
}

extension UIDevice {
    var hasNotch: Bool {
        var bottom = CGFloat()
        if #available(iOS 11.0, *) {
            bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            // Fallback on earlier versions
        }
        return bottom > 0
    }
}
