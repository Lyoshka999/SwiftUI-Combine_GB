//
//  APODModels.swift
//  Combine+SwiftUI_GB
//
//  Created by Алексей on 04.06.2023.
//

import Foundation

// MARK: - Astronomy Picture of a Day model
typealias APODResponse = [APOD]

struct APOD: Codable, Identifiable {
    let id = UUID()
    let date: String
    let explanation: String
    let hdurl: String?
    let mediaType: String
    let title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case explanation
        case hdurl
        case mediaType = "media_type"
        case title
        case url
    }
}

extension APOD: CustomStringConvertible {
    var description: String {
        " \n Date: \(date) \n Title: \(title). \n Explanation: \n \(explanation) \n Media type: \(mediaType) \n Media urls: \n \(url) \n \(hdurl ?? "") \n"
    }
}
