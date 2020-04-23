//
//  GraphQLNetworkConfiguration.swift
//  Contacts
//
//  Created by Tirupati Balan on 22/04/20.
//  Copyright © 2019 Tirupati Balan. All rights reserved.
//

import Foundation

struct GraphQLNetworkConfiguration {
    fileprivate static let StagingBaseUrl = "https://us-central1-contacts-book-76fe6.cloudfunctions.net/graphql"
    fileprivate static let ProductionBaseUrl = "https://us-central1-contacts-book-76fe6.cloudfunctions.net/graphql"

    fileprivate static let kClientID = "zenius_ios"
    fileprivate static let kClientSecret = ""

    static var properBaseUrl: String = {
        #if STAGING
        return StagingBaseUrl
        #else
        return ProductionBaseUrl
        #endif
    }()

}
