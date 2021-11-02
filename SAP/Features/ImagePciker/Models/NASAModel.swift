//
//  NASAModel.swift
//  SAP
//
//  Created by byndr on 02/11/21.
//

import Foundation

struct NASAModel: Codable {
    let copyright: String?
    let date, explanation: String
    let hdurl: String?
    let mediaType, serviceVersion, title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}
