//
//  HeaderRequest.swift
//  OneTouch
//
//  Created by Kartum Infotech on 20/05/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import Foundation

class HeaderRequestParameter {
    var parameters = [String : String]()
    
    static let Authorization = "Authorization"
    
    init() {
        addParameter(key: "Content-Type", value: "application/json")
    }

    func addParameter(key: String, value: String) {
        parameters[key] = value
    }
}
