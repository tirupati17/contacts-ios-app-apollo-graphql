//
//  GraphQLNetworkProvider+QueryHandler.swift
//  Contacts
//
//  Created by Tirupati Balan on 22/04/20.
//  Copyright © 2019 Tirupati Balan. All rights reserved.
//

import Foundation
import Apollo

extension GraphQLNetworkProvider {
    
    //For Query
    func performGraphQLQueryRequest<Query: GraphQLQuery>(_ query: Query, queryType: GraphQLNetworkQueryType, success:@escaping ((Any) -> Void), failure:@escaping ((Error?) -> Void)) {
        //Reset retry count
        self.retryCount = 0
        
        apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            switch result {
            case .success(let graphQLResult):
                if let errors = graphQLResult.errors, let error = errors.first {
                    failure(ResponseErrorModel(title: nil, detail: nil, errorImageUrl: nil, status: nil, code: nil, message: error.message, type: nil))
                    return
                }
                
                guard let graphData = graphQLResult.data else {
                    failure(ResponseErrorModel(title: nil, detail: nil, errorImageUrl: nil, status: nil, code: nil, message: "GraphData is nil for operation \(queryType.getResponseKey())", type: nil))
                    return
                }
                
                switch queryType {
                case .kContacts:
                    if let contactList = graphData.jsonObject[queryType.getResponseKey()] as? [[String: Any]] {
                        success(self.parseJsonData(contactList))
                    } else {
                        success(graphData)
                    }
                default:
                    success(graphData)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
        
    //For Mutation
    func performGraphQLMutationRequest<Mutation: GraphQLMutation>(_ mutation: Mutation, queryType: GraphQLNetworkQueryType, success:@escaping ((Any) -> Void), failure:@escaping ((Error?) -> Void)) {
        //Reset retry count
        self.retryCount = 0

        apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let errors = graphQLResult.errors, let error = errors.first {
                    failure(ResponseErrorModel(title: nil, detail: nil, errorImageUrl: nil, status: nil, code: nil, message: error.message, type: nil))
                    return
                }
                
                guard let graphData = graphQLResult.data else {
                    failure(ResponseErrorModel(title: nil, detail: nil, errorImageUrl: nil, status: nil, code: nil, message: "GraphData is nil for operation \(queryType.getResponseKey())", type: nil))
                    return
                }
                
                success(graphData)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
}
