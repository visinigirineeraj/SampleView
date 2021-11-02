//
//  EndPoint.swift
//  SAP
//
//  Created by byndr on 02/11/21.
//

import Foundation

enum NASAEndPoint: EndPointType {
    case getAPODs(count: Int)
    
    var task: HTTPTask {
        switch self {
        case .getAPODs(let count):
            let params = [Constants.Params.count: "\(count)"]
            return .requestParameters(bodyParameters: params, bodyEncoding: .jsonEncoding, urlParameters: nil)
        }
    }
}
