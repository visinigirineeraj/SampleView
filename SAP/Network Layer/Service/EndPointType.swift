//
//  EndPoint.swift
//  NetworkLayer
//
//  Created by byndr on 26/03/21.
//

import Foundation

protocol EndPointType {
    var baseURL: URL? { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

extension EndPointType {
    var baseURL: URL? { nil }
    var path: String { "" }
    var httpMethod: HTTPMethod { .get }
    var task: HTTPTask { .request }
    var headers: HTTPHeaders? { nil }
}

