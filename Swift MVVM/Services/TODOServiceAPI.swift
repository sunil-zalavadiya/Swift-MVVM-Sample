//
//  TODOServiceAPI.swift
//  Swift MVVM
//
//  Created by Kartum on 28/08/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import Foundation

public enum APIServiceError: Error {
    case invalidResponse
    case decodeError
    case noResponse
}

class TODOServiceAPI {
    
    public static let shared = TODOServiceAPI()
    
    private init() {}
    
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com/todos")!
    
    func fetchTodos<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        
        urlSession.dataTask(with: baseURL) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<209 ~= statusCode else {
                completion(.failure(APIServiceError.invalidResponse))
                return
            }
            
            do {
                let values = try JSONDecoder().decode(T.self, from: data)
                completion(.success(values))
            } catch {
                completion(.failure(APIServiceError.decodeError))
            }
            }.resume()
    }

}
