//
//  GraphQLNetworkProvider.swift
//  Contacts
//
//  Created by Tirupati Balan on 22/04/20.
//  Copyright © 2019 Tirupati Balan. All rights reserved.
//

import Foundation
import Apollo

// MARK: - Singleton Wrapper

class GraphQLNetworkProvider {
    
  static let shared = GraphQLNetworkProvider()
  var retryCount = 0

  // Configure the network transport to use the singleton as the delegate.
  private lazy var networkTransport = HTTPNetworkTransport(
    url: URL(string: GraphQLNetworkConfiguration.properBaseUrl)!,
    delegate: self
  )
    
  // Use the configured network transport in your Apollo client.
  private(set) lazy var apollo = ApolloClient(networkTransport: self.networkTransport)
}

// MARK: - Pre-flight delegate

extension GraphQLNetworkProvider: HTTPNetworkTransportPreflightDelegate {

  func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          shouldSend request: URLRequest) -> Bool {
    // If there's an authenticated user, send the request. If not, don't.
    return true
  }
  
  func networkTransport(_ networkTransport: HTTPNetworkTransport,
                        willSend request: inout URLRequest) {
                        
    // Get the existing headers, or create new ones if they're nil
    var headers = request.allHTTPHeaderFields ?? [String: String]()

    // Add any new headers you need
    // headers["x-token"] = "Bearer \(UserManager.sharedInstance.getTokenid() ?? "")"
    
    // Re-assign the updated headers to the request.
    request.allHTTPHeaderFields = headers
    
    GKLogger.log("GraphQL outgoing request: \(request)")
  }
}

// MARK: - Task Completed Delegate

extension GraphQLNetworkProvider: HTTPNetworkTransportTaskCompletedDelegate {
  func networkTransport(_ networkTransport: HTTPNetworkTransport,
                        didCompleteRawTaskForRequest request: URLRequest,
                        withData data: Data?,
                        response: URLResponse?,
                        error: Error?) {
    
    GKLogger.log("Raw task completed for request: \(request)")
                        
    if let error = error {
      GKLogger.log("Error: \(error)")
    }
    
    if let response = response {
      GKLogger.log("Response: \(response)")
    } else {
      GKLogger.log("No URL Response received!")
    }
    
    if let data = data {
      GKLogger.log("Data: \(String(describing: String(bytes: data, encoding: .utf8)))")
        
        debugPrint(data)
        
    } else {
      GKLogger.log("No data received!")
    }
  }
}

// MARK: - Retry Delegate

extension GraphQLNetworkProvider: HTTPNetworkTransportRetryDelegate {

  func networkTransport(_ networkTransport: HTTPNetworkTransport,
                        receivedError error: Error,
                        for request: URLRequest,
                        response: URLResponse?,
                        retryHandler: @escaping (_ shouldRetry: Bool) -> Void) {
        self.retryCount += 1
        let shouldRetry = self.retryCount <= 3
        retryHandler(shouldRetry)
    }
}

enum GraphQLNetworkQueryType {
    case kContacts
    
    func getResponseKey() -> String {
        switch self {
        case .kContacts:
            return "contacts"
        }
    }
}
