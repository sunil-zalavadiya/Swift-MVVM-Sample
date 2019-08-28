//
//  TODOListViewModel.swift
//  Swift MVVM
//
//  Created by Kartum on 28/08/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import Foundation

class TODOListViewModel: BaseViewModel {
    var arrTodos = [TODOModel]()
    
    func fetchTodos(completion: @escaping (Result<Bool, Error>) -> Void) {
        TODOServiceAPI.shared.fetchTodos { (result: Result<[TODOModel], Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let todos):
                self.arrTodos = todos
                completion(.success(true))
            }
        }
    }
    
    var count: Int {
        return arrTodos.count
    }
    
    func getTodo(index: Int) -> TODOModel {
        return arrTodos[index]
    }
    
    func fetchTodo(completion: @escaping (Result<Bool, Error>) -> Void) {
        _ = apiClient.fetchTodos { (response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response else {
                completion(.failure(APIServiceError.noResponse))
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let todos = try JSONDecoder().decode([TODOModel].self, from: jsonData)
                self.arrTodos = todos
                completion(.success(true))
            } catch {
                completion(.failure(APIServiceError.decodeError))
            }
        }
    }
}
