//
//  GraphQLNetworkProvider+JSONParseHandler.swift
//  Contacts
//
//  Created by Tirupati Balan on 22/04/20.
//  Copyright © 2019 Tirupati Balan. All rights reserved.
//

import Foundation

extension GraphQLNetworkProvider {
    
    func parseJsonData(_ jsonObject: Any) -> Any {
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) {
            return jsonData
        } else {
            return jsonObject
        }
    }
}
