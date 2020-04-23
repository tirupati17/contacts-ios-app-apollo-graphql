//
//  GKAPIRequest+Contacts.swift
//  Contacts
//
//  Created by Tirupati Balan on 22/04/20.
//  Copyright © 2019 Tirupati Balan. All rights reserved.
//

import Apollo

extension GKAPIRequest {
    class func contactList(_ success : ((JSON) -> Void)?, failure : ((Error) -> Void)?) {
        GraphQLNetworkProvider.shared.performGraphQLQueryRequest(ContactsQuery(), queryType: .kContacts, success: { (result) in
            let arrayObject = try! JSONDecoder().decode([Contact].self, from: result as! Data)
            success?(arrayObject as JSON)
        }) { (error) in
            failure?((error ?? nil)!)
        }
    }
    
    class func contactDetail(_ id : String, success : ((JSON) -> Void)?, failure : ((Error) -> Void)?) {
        let apiRequest = GKAPIRequest.init(requestType: GKAPIRequestType.APIRequestContactDetail)
        let urlString = GKAPIStringUrl.contactWithIdEndpoint(id)
        
        apiRequest.requestWithUrlString(urlString,
                                        requestMethod: GKRequestMethod.RequestMethodGet,
                                        params: [:],
                                        data : nil,
                                        success : success,
                                        failure : failure)
    }
    
    class func contactCreate(_ params : [String : Any], success : ((JSON) -> Void)?, failure : ((Error) -> Void)?) {
        let apiRequest = GKAPIRequest.init(requestType: GKAPIRequestType.APIRequestContactCreate)
        let urlString = GKAPIStringUrl.contactEndpoint()
        
        apiRequest.requestWithUrlString(urlString,
                                        requestMethod: GKRequestMethod.RequestMethodPost,
                                        params: params,
                                        data : nil,
                                        success : success,
                                        failure : failure)
    }
    
    class func contactUpdate(_ id : String, params : [String : Any], success : ((JSON) -> Void)?, failure : ((Error) -> Void)?) {
        let apiRequest = GKAPIRequest.init(requestType: GKAPIRequestType.APIRequestContactUpdate)
        let urlString = GKAPIStringUrl.contactWithIdEndpoint(id)
        
        apiRequest.requestWithUrlString(urlString,
                                        requestMethod: GKRequestMethod.RequestMethodPut,
                                        params: params,
                                        data : nil,
                                        success : success,
                                        failure : failure)
    }
    
    class func contactDelete(_ id : String, success : ((JSON) -> Void)?, failure : ((Error) -> Void)?) {
        let apiRequest = GKAPIRequest.init(requestType: GKAPIRequestType.APIRequestContactDelete)
        let urlString = GKAPIStringUrl.contactWithIdEndpoint(id)
        
        apiRequest.requestWithUrlString(urlString,
                                        requestMethod: GKRequestMethod.RequestMethodDelete,
                                        params: [:],
                                        data : nil,
                                        success : success,
                                        failure : failure)
    }
}

