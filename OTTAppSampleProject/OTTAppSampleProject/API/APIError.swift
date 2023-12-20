//
//  APIError.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/20/23.
//

enum APIError: Error {
    case decodingFailure(localizedDescription: String)
    case invalidResponse(statusCode: Int)
    case emptyResponse
    case emptyData
}
