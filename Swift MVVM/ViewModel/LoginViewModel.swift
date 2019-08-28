//
//  LoginViewModel.swift
//  Swift MVVM
//
//  Created by Kartum on 28/08/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import Foundation

class BaseViewModel {
    lazy var apiClient = APIClient()
    var errorMessage = ""
}

class LoginViewModel: BaseViewModel {
    let model = LoginModel()
    
    func validation() -> Bool {
        if model.username.isEmpty {
            errorMessage = "Please enter email"
        } else if !model.username.isValidEmail {
            errorMessage = "Please enter valid email"
        } else if model.password.isEmpty {
            errorMessage = "Please enter password"
        } else {
            return true
        }
        return false
    }
    
    func login(completion: @escaping ((Result<Bool, Error>) -> Void)) {
        // Api calling
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(.success(true))
        }
    }
}
