//
//  ApiParameter.swift
//  OneTouch
//
//  Created by Kartum Infotech on 20/05/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import Foundation

class ParameterRequest {
    init() {}
    
    var parameters = [String: Any]()

    // Profile Setup
    static let user_full_name = "user_full_name"
    static let user_address = "user_address"
    
    // Save Task
    static let task_title = "task_title"
    static let task_type = "task_type"
    
    // Task List
    static let task_list_type = "task_list_type"
    static let offset = "offset"
    static let sort_type = "sort_type"
    
    func addParameter(key: String, value: Any?) {
        parameters[key] = value
    }
    
}

class FileParameterRequest {
    var parameters = [String: Any]()
    
    static let file_data = "file_data"
    static let param_name = "param_name"
    static let file_name = "file_name"
    static let mime_type = "mime_type"
    
    init() {}
    
    func addParameter(key: String, value: Any?) {
        parameters[key] = value
    }
}
