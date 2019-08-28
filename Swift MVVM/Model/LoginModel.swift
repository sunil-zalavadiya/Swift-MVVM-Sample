//
//  LoginModel.swift
//  Swift MVVM
//
//  Created by Kartum on 28/08/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import Foundation

class LoginModel {
    var username: String = ""
    var password: String = ""
    
    init() {}
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
