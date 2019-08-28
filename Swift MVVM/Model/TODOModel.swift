//
//  TODOModel.swift
//  Swift MVVM
//
//  Created by Kartum on 28/08/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import Foundation

struct TODOModel: Codable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}

extension TODOModel {
    var getId: String {
        return String(id)
    }
}
