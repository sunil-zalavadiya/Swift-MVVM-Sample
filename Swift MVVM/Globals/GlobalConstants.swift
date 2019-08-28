//
//  GlobalConstants.swift
//  OneTouch
//
//  Created by Kartum Infotech on 20/05/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import UIKit

// MARK: - Google Auth
var GoogleSignIn_CLIENT_ID = "xxxxxxx.apps.googleusercontent.com"
var GOOGLE_API_KEY = "xxxxxxxx"

struct ResponseStatus {
    static let success = 200
    static let fail = 0
    static let serverError = 500
}

struct API {
    
    static var BASE_URL = "https://google.com/"
    
    static let LOGIN                           =   BASE_URL + "login"
    
    static let PROFILE_SETUP                   =   BASE_URL + "profile_setup"
    static let PHONE_VERIFY                    =   BASE_URL + "phone_verify"
    static let RESEND_CODE                     =   BASE_URL + "phone_resend_code"
    
    static let TODOs                           =   "https://jsonplaceholder.typicode.com/todos"
}
