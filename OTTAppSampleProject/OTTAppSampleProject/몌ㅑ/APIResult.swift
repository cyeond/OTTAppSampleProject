//
//  APIResult.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/14/23.
//

struct APIResult: Codable {
    let page, totalPages, totalResults: Int
    let results: [ContentData]
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
