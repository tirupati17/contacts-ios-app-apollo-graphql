//
//  GKURLSessionManager.swift
//  Contacts
//
//  Created by Tirupati Balan on 16/04/19.
//  Copyright © 2019 Tirupati Balan. All rights reserved.
//


extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

class GKURLSessionManager : URLSession {
    class var defaultSharedInstance : URLSession {
        struct defaultSingleton {
            static let instance = URLSession(configuration: .default)
        }
        return defaultSingleton.instance
    }
    
    class var ephemeralSharedInstance : URLSession {
        struct ephemeralSingleton {
            static let instance = URLSession(configuration: .ephemeral)
        }
        return ephemeralSingleton.instance
    }
    
    class var backgroundSharedInstance : URLSession {
        struct backgroundSingleton {
            static let instance = URLSession(configuration: URLSessionConfiguration.background(withIdentifier: GKConstant.AppBundleName))
        }
        return backgroundSingleton.instance
    }
    
    class func performRequest(_ apiRequest: GKAPIRequest, success: ((JSON) ->
        Void)!, failure:((Error) -> Void)!) -> URLSessionTask {
        let fullUrlString = self.fullPathForRequest(apiRequest)
        
        let url = URL(string: fullUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: url!)
        
        GKLogger.log(fullUrlString)
        GKLogger.log(apiRequest.params)
        
        var sessionTask : URLSessionTask!
        switch apiRequest.requestMethod {
        case GKRequestMethod.RequestMethodGet?:
            sessionTask = GKURLSessionManager.defaultSharedInstance.dataTask(with: url!, completionHandler: { (data, response, error) in
                self.responseHandle(data: data, response: response, error: error, success: success, failure: failure)
            })
            sessionTask.resume()
            break
        case GKRequestMethod.RequestMethodPost?:
            request.httpMethod = "POST"
            request.setValue(apiRequest.contentType, forHTTPHeaderField: "Content-Type")
            if let httpBody = try? JSONSerialization.data(withJSONObject: apiRequest.params, options: [])  {
                request.httpBody = httpBody
            }
            
            sessionTask = GKURLSessionManager.defaultSharedInstance.dataTask(with: request, completionHandler: { (data, response, error) in
                self.responseHandle(data: data, response: response, error: error, success: success, failure: failure)
            })
            sessionTask.resume()
            break
        case GKRequestMethod.RequestMethodPut?:
            request.httpMethod = "PUT"
            request.setValue(apiRequest.contentType, forHTTPHeaderField: "Content-Type")
            
            if let httpBody = try? JSONSerialization.data(withJSONObject: apiRequest.params, options: [])  {
                request.httpBody = httpBody
            }
            sessionTask = GKURLSessionManager.defaultSharedInstance.dataTask(with: request, completionHandler: { (data, response, error) in
                self.responseHandle(data: data, response: response, error: error, success: success, failure: failure)
            })
            sessionTask.resume()
            break
        case GKRequestMethod.RequestMethodDelete?:
            request.httpMethod = "DELETE"
            sessionTask = GKURLSessionManager.defaultSharedInstance.dataTask(with: request, completionHandler: { (data, response, error) in
                self.responseHandle(data: data, response: response, error: error, success: success, failure: failure)
            })
            sessionTask.resume()
            break
        default:
            break
        }
        return sessionTask;
    }
    
    class func responseHandle(data : Data?, response : URLResponse?, error : Error?, success: ((JSON) ->
        Void)!, failure:((Error) -> Void)!) {
        if let error = error {
            failure(error)
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            let error: LocalizedDescriptionError = GKError.customError(message: "Invalid response")
            failure(error)
            return
        }
        var responseError = ResponseError(errors: [])
        if let mimeType = response.mimeType,
            mimeType == "application/json",
            let data = data,
            let _ = String(data: data, encoding: .utf8) {
            do {
                responseError = try JSONDecoder().decode(ResponseError.self, from: data)
            } catch {
                //print(error)
                //print(dataString)
            }
        }
        let customMessage = responseError.errors?.count ?? 0 >= 1 ? responseError.errors?[0] : ""
        switch (response.statusCode) {
            case 200...299:
                success(data as JSON)
                break
            case 404:
                let error: LocalizedDescriptionError = GKError.customError(message: customMessage ?? "Not Found")
                failure(error)
                break
            case 422:
                let error: LocalizedDescriptionError = GKError.customError(message: customMessage ?? "Validation Errors")
                failure(error)
                break
            case 500:
                let error: LocalizedDescriptionError = GKError.customError(message: customMessage ?? "Internal Server Error")
                failure(error)
                break
            default:
                let error: LocalizedDescriptionError = GKError.customError(message: customMessage ?? "Invalid status code")
                failure(error)
        }
    }
    
    class func fullPathForRequest(_ apiRequest : GKAPIRequest) -> String {
        var fullPath = self.fullPathWithUrlString(apiRequest.urlString!, apiRequest.requestType!)
        switch apiRequest.requestType {
            case .APIRequestContactList?:
                fullPath = "\(GKAPIConstant.sharedConstant.baseUrl())\(fullPath)"
                break
            default:
                fullPath = "\(GKAPIConstant.sharedConstant.baseUrl())\(fullPath)"
                break
        }
        return fullPath
    }
    
    class func fullPathWithUrlString(_ urlString : String, _ apiRequestType : GKAPIRequestType) -> String {
        if (!urlString.isEmpty) {
            var apiVersion = ""
            switch apiRequestType {
            case .APIRequestContactList:
                apiVersion = GKAPIConstant.apiVersion1
                break
            default:
                apiVersion = GKAPIConstant.apiVersion2
                break
            }
            return String.init(format: "%@%@", apiVersion, urlString)
        } else {
            GKLogger.log("Empty URL string")
            return ""
        }
    }
    
    class func createBody(parameters: [String: Any],
                          boundary: String,
                          requestType: GKAPIRequestType,
                          data: Data?,
                          mimeType: String?,
                          filename: String?) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        if let filename = filename {
            body.appendString("Content-Disposition: form-data; name=\"zipMultipartFile\"; filename=\"\(filename)\"\r\n")
        }
        if let mimeType = mimeType {
            body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        }
        if let data = data {
            body.append(data)
        }
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--\r\n")))
        
        return body as Data
    }
}
