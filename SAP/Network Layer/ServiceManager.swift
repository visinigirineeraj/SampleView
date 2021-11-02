//
//  ServiceManager.swift
//  SAP
//
//  Created by byndr on 02/11/21.
//

import Foundation


struct ServiceManager<T: Codable> {
    
    func request(endPoint:EndPointType, completion:@escaping (T?, Error?) -> Void) {
        let configuration = AppConfigurations.shared
        let router = Router.init(configurationProtocol: configuration)
        router.request(endPoint) { (data, response, apiError) in
            do {
                if let data = data, data.count > 0 {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    NetworkLogger.log(model: model)
                    NetworkLogger.log(string: String(data: data, encoding: .utf8))
                    completion(model, nil)
                } else {
                    completion(nil, apiError)
                }
            } catch {
                completion(nil, error)
            }
        }
    }
}
