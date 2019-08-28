//
//  String+Extension.swift
//  Swift MVVM
//
//  Created by Kartum on 28/08/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import Foundation

extension String {
    
    public func toInt() -> Int? {
        let formatter =  NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        if let num = formatter.number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }

    /// EZSE: Converts String to Double
    public func toDouble() -> Double? {
        let formatter =  NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        if let num = formatter.number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Float
    public func toFloat() -> Float? {
        let formatter =  NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        if let num = formatter.number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    func getUtf8Data() -> Data {
        return self.data(using: String.Encoding.utf8)!
    }
    
    /// EZSE: Converts String to Bool
    public func toBool() -> Bool? {
        return (self as NSString).boolValue
    }
    
    /// EZSE: Trims white space and new line characters
    public mutating func trim() {
        self = self.trimmed()
    }
    
    /// EZSE: Trims white space and new line characters, returns a new string
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let phoneRegEx = "^\\d{10}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&.*-~`\"'#()+,:;<>=^_{}\\]\\[])[A-Za-z\\d$@$!%*?&.*-~`\"'#()+,:;<>=^_{}\\]\\[]{6,}"//"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    func getDateWithFormate(formate: String, timezone: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(abbreviation: timezone)
        
        return formatter.date(from: self)! as Date
    }
    
    // *------------*
    // Normal string to get Encode string
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    // Encoded string to get normal string
    func fromBase64() -> String? {
        guard let decodedData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return String(data: decodedData, encoding: .utf8)
    }
    // *------------*
    
    func notificationName() -> Notification.Name {
        return Notification.Name(self)
    }
    
    func encodedUrlComponentString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    func encodedUrlQueryString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func slice(from: String, to: String) -> String? {    // get Full string to perticular string
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
}
