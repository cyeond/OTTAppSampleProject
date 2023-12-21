//
//  Content.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/12/23.
//

enum ContentType: String {
    case tv
    case movie
}

struct ContentData: Codable, Hashable {
    let id: Int
    let voteCount: Int?
    let originalTitle, title, originalName, name, originalLanguage, releaseDate, posterPath: String?
    let popularity, voteAverage: Double?
    var previewImageUrl: String {
        guard let posterPath = posterPath else { return Constants.PLACEHOLDER_IMAGE_URL }
        return Constants.API_IMAGE_URL_PREFIX + posterPath
    }
    var rating: Double {
        return voteAverage ?? 0.0
    }
    var ratingCount: Int {
        return voteCount ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case id, popularity, title, name
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct Content: Hashable {
    var type: ContentType?
    var data: ContentData
}
