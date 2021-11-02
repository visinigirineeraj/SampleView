//
//  NetworkLogger.swift
//  NetworkLayer
//
//  Created by byndr on 26/03/21.
//

import Foundation

class NetworkLogger {
    static func log(request: URLRequest) {
        
        print("\n - - - - - - - - - - Request Details - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
                        \(urlAsString) \n\n
                        \(method) \(path)?\(query) HTTP/1.1 \n
                        HOST: \(host)\n
                        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print(logOutput)
    }
  
    static func log(response: URLResponse) {
        print("\n - - - - - - - - - - Response Details - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        print(response)
    }
    
    static func log(model: Codable) {
        print("\n - - - - - - - - - - Response Model Details - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        print(model)
    }
    static func log(error: Error?) {
        print("\n - - - - - - - - - - Error Details - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        print(error)
    }
    
    static func log(string: String?) {
        print("\n - - - - - - - - - - String Details - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        print(string)
    }
}
