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
    var apiErrorRelay = PublishRelay<Void>()
    
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
}
