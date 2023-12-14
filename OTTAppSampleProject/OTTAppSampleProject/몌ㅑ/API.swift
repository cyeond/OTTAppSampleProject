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
        return RxAlamofire.data(.get, type.url)
            .debug()
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { try JSONDecoder().decode(APIResult.self, from: $0) }
            
    }
}
