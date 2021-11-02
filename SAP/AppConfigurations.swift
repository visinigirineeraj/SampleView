//
//  AppConfigurations.swift
//  SAP
//
//  Created by byndr on 02/11/21.
//

import Foundation

struct AppConfigurations: NetworkConfigurationProtocol {
    
    static let shared = AppConfigurations()
    
    var baseURL: String {
        return Constants.baseURL
    }
    
    var stubEnvironment: Bool {
        return false
    }
    
    var sslPining: Bool {
        return false
    }
    
    var certNames: [String] {
        return []
    }
    
    var baseParams: Parameters {
        return [Constants.Params.apiKey: Constants.apiKeyValue]
    }
    
    var certType: String {
        return ""
    }
    
    var bundle: Bundle {
        return Bundle.main
    }
    
    var timeoutInterval: TimeInterval {
        return 60
    }
}
