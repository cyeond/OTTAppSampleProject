//
//  Content.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/12/23.
//

enum ContentType {
    case tv
    case movie
}

struct ContentData: Hashable, Codable {
    var title: String
    var subtitle: String?
    var imageUrl: String
}

struct Content: Hashable {
    var type: ContentType
    var data: ContentData
}
