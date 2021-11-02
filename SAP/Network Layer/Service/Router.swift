//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by byndr on 26/03/21.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()


protocol NetworkConfigurationProtocol {
    var baseURL: String { get }
    var stubEnvironment: Bool { get }
    var sslPining: Bool { get }
    var certNames: [String] { get }
    var baseParams: Parameters { get }
    var certType: String { get }
    var bundle: Bundle { get }
    var timeoutInterval: TimeInterval { get }
}

protocol NetworkRouter {
    var networkConfiguration: NetworkConfigurationProtocol { get set}
    func request(_ route: EndPointType, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router: NetworkRouter {
    
    var networkConfiguration: NetworkConfigurationProtocol
    
    private var task: URLSessionTask?

    init(configurationProtocol: NetworkConfigurationProtocol) {
        self.networkConfiguration = configurationProtocol
    }
    
    func request(_ route: EndPointType, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            guard let request = try self.buildRequest(from: route) else { return }
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let response = response {
                    NetworkLogger.log(response: response)
                }
                    
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPointType) throws -> URLRequest? {
        
        guard var url = URL(string: self.networkConfiguration.baseURL) else { return nil }
        if let endPointUrl = route.baseURL {
            url = endPointUrl
        }
        let urlString = url.absoluteString.appending(route.path)
        guard var url = URL(string: urlString) else {
            return nil
        }
        var request = URLRequest(url:url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                self.addAdditionalHeaders(route.headers, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                let headers: HTTPHeaders = route.headers?.merging(additionalHeaders ?? [:], uniquingKeysWith: { (dict1, dict2) -> String in
                    return dict2
                }) ?? HTTPHeaders()
                self.addAdditionalHeaders(headers, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            print("The parameters are \(String(describing: bodyParameters))")
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}


// MARK:- Router Response Methods
extension Router {
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

