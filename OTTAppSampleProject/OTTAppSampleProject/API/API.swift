//
//  API.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/13/23.
//

import Foundation
import RxSwift
import RxAlamofire

struct API {
    static func getData(type: APIType) -> Observable<APIResult> {
        return RxAlamofire.requestData(.get, type.url)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { (response, data) in
                guard 200...299 ~= response.statusCode else { throw APIError.invalidResponse(statusCode: response.statusCode)}
                
                return data
            }
            .map { data in
                do {
                    return try JSONDecoder().decode(APIResult.self, from: data)
                } catch {
                    throw APIError.decodingFailure(localizedDescription: error.localizedDescription)
                }
            }
    }
    
    static func getDetails(type: APIType) -> Observable<ContentData> {
        return RxAlamofire.requestData(.get, type.url)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { (response, data) in
                guard 200...299 ~= response.statusCode else { throw APIError.invalidResponse(statusCode: response.statusCode)}
                
                return data
            }
            .map { data in
                do {
                    return try JSONDecoder().decode(ContentData.self, from: data)
                } catch {
                    throw APIError.decodingFailure(localizedDescription: error.localizedDescription)
                }
            }
    }
}
