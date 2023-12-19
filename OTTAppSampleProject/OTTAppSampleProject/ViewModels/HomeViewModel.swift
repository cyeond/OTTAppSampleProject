//
//  HomeViewModel.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/14/23.
//

import Foundation
import RxSwift

class HomeViewModel: ObservableObject {
    var tvResults = PublishSubject<[APIResult]>()
    var movieResults = PublishSubject<[APIResult]>()
    var currentContentType: ContentType = .tv
    
    private let disposeBag = DisposeBag()
    
    func getResultsData() {
        switch currentContentType {
        case .tv:
            getTVResults()
        case .movie:
            getMovieResults()
        }
    }
    
    func getTVResults() {
        Observable.combineLatest(API.getData(type: .onTheAirTV), API.getData(type: .airingTodayTV), API.getData(type: .weeklyTrending(.tv)), API.getData(type: .topRated(.tv)), API.getData(type: .popular(.tv)))
            .map { [$0.0, $0.1, $0.2, $0.3, $0.4] }
            .bind { self.tvResults.onNext($0) }
            .disposed(by: disposeBag)
    }
    
    func getMovieResults() {
        Observable.combineLatest(API.getData(type: .upcomingMovies), API.getData(type: .nowPlayingMovies), API.getData(type: .weeklyTrending(.movie)), API.getData(type: .topRated(.movie)), API.getData(type: .popular(.movie)))
            .map { [$0.0, $0.1, $0.2, $0.3, $0.4] }
            .bind { self.movieResults.onNext($0) }
            .disposed(by: disposeBag)
    }
}
