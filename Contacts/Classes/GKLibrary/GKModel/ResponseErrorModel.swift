//
//  ResponseErrorModel.swift
//  Zenius
//
//  Created by Tirupati Balan
//

import Foundation

struct ResponseErrorArrayModel: Codable, Error {
    var errors: ResponseErrorModel?
    
    enum CodingKeys: String, CodingKey {
        case errors = "error"
    }
}

struct ResponseErrorModel: Codable, Error {
    var title: String?
    var detail: String?
    var errorImageUrl: String?
    var status: NSNumber?
    var code: Int?
    var message: String?
    var type: String?
    var showRetry: Bool?

    enum CodingKeys: String, CodingKey {
        case title
        case detail
        case code
        case message
        case type
    }
}

extension ResponseErrorModel {
    init(systemError: NSError) {
        self.init()
        self.status = systemError.code as NSNumber

        if systemError.code == NSURLErrorNotConnectedToInternet ||
            systemError.code == NSURLErrorNetworkConnectionLost {
            self = ResponseErrorModel(title: "No Connection", detail: nil, errorImageUrl: nil, status: nil, code: nil, message: "Please check network connectivity", type: nil, showRetry: true)
        } else {
            self = ResponseErrorModel(title: "Oop's something went wrong.", detail: nil, errorImageUrl: nil, status: nil, code: nil, message: "Please try again.", type: nil, showRetry: true)
        }
    }
}
