//
//  ApiManager.swift
//  OneTouch
//
//  Created by Kartum Infotech on 20/05/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//


import Foundation
import Alamofire

class ApiManager {
    
    public static let apiSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 300
        
        return SessionManager(configuration: configuration)
    }()
    
    class func callApi(apiURL: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, parameterEncoding: ParameterEncoding, success successBlock:@escaping ((Any?, Int?) -> Void), failure failureBlock: ((Error, Int?) -> Bool)?) -> DataRequest {
        var finalParameters = [String: Any]()
        if parameters != nil {
            finalParameters = parameters!
        }
        
        DLog("parameters = ", finalParameters)
        DLog("apiURL = ", apiURL)
        
        return apiSessionManager.request(apiURL, method: method, parameters: finalParameters, encoding: parameterEncoding, headers: headers)
            .responseString { response in
                
                DLog("Response String: \(String(describing: response.result.value))")
            }
            .responseJSON { response in
                
                DLog("Response Error: ", response.result.error)
                DLog("Response JSON: ", response.result.value)
                DLog("response.request: ", response.request?.allHTTPHeaderFields)
                DLog("Response Status Code: ", response.response?.statusCode)
                
                DispatchQueue.main.async {
                    if response.result.error == nil {
                        let responseObject = response.result.value
                        
                        if let status = responseObject as? [String : Any], (status["status"] as? String ?? "") == "3" {
                            // logout form app if session expire
                        }
                        
                        successBlock(responseObject, response.response?.statusCode)
                        
                    } else {
                        if failureBlock != nil && failureBlock!(response.result.error! as NSError, response.response?.statusCode) {
                            if let statusCode = response.response?.statusCode {
                                ApiManager.handleAlamofireHttpFailureError(statusCode: statusCode)
                            }
                        }
                    }
                }
        }
    }
    
    class func callApiWithUpload(apiURL: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, fileDataParameters: [FileParameterRequest]? = nil, headers: [String: String]? = nil, success successBlock:@escaping ((Any?, Int?) -> Void), failure failureBlock: ((Error, Int?) -> Bool)?) {
        
        var finalParameters = [String: Any]()
        if parameters != nil {
            finalParameters = parameters!
        }
        
        DLog("parameters = ", finalParameters)
        DLog("apiURL = ", apiURL)
        
        return apiSessionManager.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append("".data(using: String.Encoding.utf8)!, withName: "")
            
            for (key, value) in finalParameters {
                multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
            
            if fileDataParameters != nil && (fileDataParameters?.count)! > 0 {
                for i in 0...(fileDataParameters!.count - 1) {
                    let dict = fileDataParameters![i].parameters
                    multipartFormData.append(dict["file_data"] as! Data, withName: dict["param_name"] as! String, fileName: dict["file_name"] as! String, mimeType: dict["mime_type"] as! String)
                }
            }
            
        }, to: apiURL, method: method, headers: headers, encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseString { response in
                    
                    DLog("Response String: \(String(describing: response.result.value))")
                }
                
                upload.responseJSON { response in
                    
                    DLog("Response Error: ", response.result.error)
                    DLog("Response JSON: ", response.result.value)
                    DLog("response.request: ", response.request?.allHTTPHeaderFields)
                    DLog("Response Status Code: ", response.response?.statusCode)
                    
                    DispatchQueue.main.async {
                        if response.result.error == nil {
                            let responseObject = response.result.value
                            
                            if let status = responseObject as? [String : Any], (status["status"] as? String ?? "") == "3" {
                                // logout form app if session expire
                            }
                            
                            successBlock(responseObject, response.response?.statusCode)
                        } else {
                            if failureBlock != nil && failureBlock!(response.result.error! as NSError, response.response?.statusCode) {
                                if let statusCode = response.response?.statusCode {
                                    ApiManager.handleAlamofireHttpFailureError(statusCode: statusCode)
                                }
                            }
                        }
                    }
                }
            case .failure(let encodingError):
                
                Utility.showMessageAlert(title: "Error", andMessage: "\(encodingError)", withOkButtonTitle: "OK")
                
            }
        })
    }
    
    class func requestApiFormData(method: Alamofire.HTTPMethod, urlString: String, parameters: [String: AnyObject]? = nil, headers: [String: String]? = nil, success successBlock:@escaping (([String: AnyObject]) -> Void), failure failureBlock:((NSError) -> Bool)?) -> DataRequest {
        var finalParameters = [String: AnyObject]()
        
        if(parameters != nil) {
            finalParameters = parameters!
        }
        
        let postData = NSMutableData()
        
        var index: Int = 0
        
        var body = ""
        let boundary = "----Boundary7MA4YWxkTrZu0gW"
        
        for (key, value) in finalParameters {
            let paramName = key
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            body += "\r\n\r\n\(value)"
        }
        
        for (key, value) in finalParameters {
            if(index == 0) {
                postData.append("\(key)=\(value)".data(using: String.Encoding.utf8)!)
            } else {
                postData.append("&\(key)=\(value)".data(using: String.Encoding.utf8)!)
            }
            
            index += 1
        }
        
        DLog("parameters = \(finalParameters)")
        DLog("urlString = \(urlString)")
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.timeoutInterval = 60
        request.httpMethod = method.rawValue
        
        //request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = body.data(using: .utf8)//postData as Data
        
        return Alamofire.request(request)
            .responseString { response in
                
                DLog("Response String: \(String(describing: response.result.value))")
                
            }
            .responseJSON { response in
                
                DLog("Response Error: \(String(describing: response.result.error))")
                DLog("Response JSON: \(String(describing: response.result.value))")
                DLog("response.request:  \(String(describing: response.request?.allHTTPHeaderFields))")
                DLog("response.request--> \(String(describing: response.request))")
                
                if(response.result.error == nil) {
                    let responseObject = response.result.value as! [NSObject: AnyObject]
                    _ = responseObject as! [String : AnyObject]
                    
                    if let status = responseObject as? [String : Any], (status["status"] as? String ?? "") == "3" {
                        // logout form app if session expire
                    }
                    
                    successBlock(responseObject as! [String : AnyObject])
                } else {
                    
                    if(failureBlock != nil && failureBlock!(response.result.error! as NSError)) {
                        if let statusCode = response.response?.statusCode {
                            ApiManager.handleAlamofireHttpFailureError(statusCode: statusCode)
                        }
                    }
                }
        }
        
    }
    
    class func handleAlamofireHttpFailureError(statusCode: Int) {
        switch statusCode {
        case NSURLErrorUnknown:
            Utility.showMessageAlert(title: "Error", andMessage: "Ooops!! Something went wrong, please try after some time!", withOkButtonTitle: "OK")
            
        case NSURLErrorCancelled:
            break
        case NSURLErrorTimedOut:
            Utility.showMessageAlert(title: "Error", andMessage: "The request timed out, please verify your internet connection and try again.", withOkButtonTitle: "OK")
            
        case NSURLErrorNetworkConnectionLost:
            Utility.showMessageAlert(title: "Internet!", andMessage: "Please check your internet connection or try again later", withOkButtonTitle: "OK")
            break
            
        case NSURLErrorNotConnectedToInternet:
            Utility.showMessageAlert(title: "Internet!", andMessage: "Please check your internet connection or try again later", withOkButtonTitle: "OK")
            break
            
        default:
            Utility.showMessageAlert(title: "Error", andMessage: "Ooops!! Something went wrong, please try after some time!", withOkButtonTitle: "OK")
        }
    }
    
    class func isNetworkReachable() -> Bool {
        return NetworkReachabilityManager(host: "www.apple.com")?.isReachable ?? false
    }

}
