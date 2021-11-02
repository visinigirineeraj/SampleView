//
//  HTTPMethod.swift
//  NetworkLayer
//
//  Created by byndr on 26/03/21.
//

import Foundation

public enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    
    var statusCode: [Int] {
        switch self {
        case .get:
            return [200, 204]
        case .post:
            return [200, 201]
        default:
            return [200]
        }
    }
}

public enum Result<String>{
    case success
    case failure(String)
}

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}
