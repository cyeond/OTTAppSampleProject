//
//  SearchViewModel.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/21/23.
//

import RxSwift
import RxRelay

class SearchViewModel {
    var suggestionResultRelay = PublishRelay<APIResult>()
    var searchResultRelay = PublishRelay<APIResult>()
    var apiErrorRelay = PublishRelay<Void>()
    let searchHistoryCellTappedRelay = PublishRelay<String>()
    let deleteSearchHistoryCellRelay = PublishRelay<(String, Int)>()
    var testSearchHistory = ["TEST1", "TEST2", "TEST3", "TEST4", "TEST5"]
    
    private let disposeBag = DisposeBag()
    
    func getSuggestionData() {
        API.getData(type: .weeklyTrending(.none))
            .subscribe(with: self, onNext: { weakSelf, result in
                weakSelf.suggestionResultRelay.accept(result)
            }, onError: { weakSelf, error in
                weakSelf.apiErrorRelay.accept(())
            })
            .disposed(by: disposeBag)
    }
    
    func getSearchData(text: String) {
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            apiErrorRelay.accept(())
            return
        }
        
        API.getData(type: .keywordSearching(encodedText))
            .subscribe(with: self, onNext: { weakSelf, result in
                weakSelf.searchResultRelay.accept(result)
            }, onError: { weakSelf, error in
                weakSelf.apiErrorRelay.accept(())
            })
            .disposed(by: disposeBag)
    }
}
