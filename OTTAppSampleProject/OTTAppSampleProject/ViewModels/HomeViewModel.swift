//
//  HomeViewModel.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/14/23.
//

import Foundation
import RxSwift

class HomeViewModel: ObservableObject {
    var tvContentData = PublishSubject<APIResult>()
    var tvResults = PublishSubject<[APIResult]>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        Observable.combineLatest(API.getData(type: .onTheAirTV), API.getData(type: .airingTodayTV), API.getData(type: .weeklyTrending(.tv)), API.getData(type: .topRated(.tv)), API.getData(type: .popular(.tv)))
            .map { [$0.0, $0.1, $0.2, $0.3, $0.4] }
            .bind { self.tvResults.onNext($0) }
            .disposed(by: disposeBag)
            
    }
}
