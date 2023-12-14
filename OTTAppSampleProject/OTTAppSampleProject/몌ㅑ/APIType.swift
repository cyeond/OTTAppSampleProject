//
//  APIType.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/14/23.
//

enum APIType {
    case keywordSearching(String)
    case topRated(ContentType)
    case popular(ContentType)
    case weeklyTrending(ContentType)
    case upcomingMovies
    case nowPlayingMovies
    case onTheAirTV
    case airingTodayTV
    
    var url: String {
        switch self {
        case .keywordSearching(let keyword):
            return Constants.API_ENDPOINT + "/search/multi" + "?api_key=" + Constants.API_KEY + "&query=" + keyword + "&language=ko"
        case .popular(let type):
            return Constants.API_ENDPOINT + "/" + type.rawValue + "/popular" + "?api_key=" + Constants.API_KEY + "&language=ko"
        case .topRated(let type):
            return Constants.API_ENDPOINT + "/" + type.rawValue + "/top_rated" + "?api_key=" + Constants.API_KEY + "&language=ko"
        case .weeklyTrending(let type):
            return Constants.API_ENDPOINT + "/trending/" + type.rawValue + "/week" + "?api_key=" + Constants.API_KEY + "&language=ko"
        case .upcomingMovies:
            return Constants.API_ENDPOINT + "/movie/upcoming" + "?api_key=" + Constants.API_KEY + "&language=ko"
        case .nowPlayingMovies:
            return Constants.API_ENDPOINT + "/movie/now_playing" + "?api_key=" + Constants.API_KEY + "&language=ko"
        case .onTheAirTV:
            return Constants.API_ENDPOINT + "/tv/on_the_air" + "?api_key=" + Constants.API_KEY + "&language=ko"
        case .airingTodayTV:
            return Constants.API_ENDPOINT + "/tv/airing_today" + "?api_key=" + Constants.API_KEY + "&language=ko"
        }
    }
}
