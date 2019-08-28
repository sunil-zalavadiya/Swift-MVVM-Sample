//
//  APIClient.swift
//  OneTouch
//
//  Created by Kartum Infotech on 20/05/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    
    private func callApi(apiURL: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, completion completionBlock: @escaping ([String : Any]?, Error?) -> Void, parameterEncoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
        let headers = HeaderRequestParameter()
        return ApiManager.callApi(apiURL: apiURL, method: method, parameters: parameters, headers: headers.parameters, parameterEncoding: parameterEncoding, success: { (response, status) in
            DispatchQueue.main.async {
                let responseObj = response as? [String : Any]
                completionBlock(responseObj, nil)
            }
        }, failure: { (error, status) -> Bool in
            DLog(error, status)
            DispatchQueue.main.async {
                completionBlock(nil, error)
            }
            return true
        })
    }
    
    private func callApi(apiURL: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, completion completionBlock: @escaping ([Any]?, Error?) -> Void, parameterEncoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
        let headers = HeaderRequestParameter()
        return ApiManager.callApi(apiURL: apiURL, method: method, parameters: parameters, headers: headers.parameters, parameterEncoding: parameterEncoding, success: { (response, status) in
            DispatchQueue.main.async {
                let responseObj = response as? [Any]
                completionBlock(responseObj, nil)
            }
        }, failure: { (error, status) -> Bool in
            DLog(error, status)
            DispatchQueue.main.async {
                completionBlock(nil, error)
            }
            return true
        })
    }
    
    private func callApiWithUpload(apiURL: String, fileArr: [FileParameterRequest], method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, completion completionBlock: @escaping ([String : Any]?, Error?) -> Void) {
        ApiManager.callApiWithUpload(apiURL: apiURL, method: method, parameters: parameters, fileDataParameters: fileArr, headers: headers, success: { (response, status) in
            DispatchQueue.main.async {
                let responseObj = response as? [String : Any]
                completionBlock(responseObj, nil)
            }
        }, failure: { (error, status) -> Bool in
            DLog(error, status)
            DispatchQueue.main.async {
                completionBlock(nil, error)
            }
            return true
        })
    }
    
    
    // Authentication
    func login(parameters: ParameterRequest, completion completionBlock: @escaping ([String : Any]?, Error?) -> Void) -> DataRequest {
        return callApi(apiURL: API.LOGIN, method: .post, parameters: parameters.parameters, headers: nil, completion: completionBlock)
    }
    
    func profileSetup(parameters: ParameterRequest, fileArray: [FileParameterRequest], completion completionBlock: @escaping ([String : Any]?, Error?) -> Void) {
        callApiWithUpload(apiURL: API.PROFILE_SETUP, fileArr: fileArray, method: .post, parameters: parameters.parameters, headers: nil, completion: completionBlock)
    }
    
    func phoneVerify(parameters: ParameterRequest, completion completionBlock: @escaping ([String : Any]?, Error?) -> Void) -> DataRequest {
        return callApi(apiURL: API.PHONE_VERIFY, method: .post, parameters: parameters.parameters, headers: nil, completion: completionBlock)
    }
    
    func resendCode(parameters: ParameterRequest, completion completionBlock: @escaping ([String : Any]?, Error?) -> Void) -> DataRequest {
        return callApi(apiURL: API.RESEND_CODE, method: .post, parameters: parameters.parameters, headers: nil, completion: completionBlock)
    }
    
    func fetchTodos(completion completionBlock: @escaping ([Any]?, Error?) -> Void) -> DataRequest {
        return callApi(apiURL: API.TODOs, method: .get, parameters: nil, headers: nil, completion: completionBlock)
    }
    
}
