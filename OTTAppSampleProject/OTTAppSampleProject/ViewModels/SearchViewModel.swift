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
    var detailResultRelay = PublishRelay<Content>()
    var apiErrorRelay = PublishRelay<Void>()
    let searchHistoryCellTappedRelay = PublishRelay<String>()
    let deleteSearchHistoryCellRelay = PublishRelay<String>()
    let suggestedKeywordTappedRelay = PublishRelay<String>()
    let buttonWithContentTappedRelay = PublishRelay<Content>()
    
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
    
    func getDetailData(content: Content) {
        guard let contentType = content.type else {
            apiErrorRelay.accept(())
            return
        }
        
        API.getDetails(type: .details(contentType, String(content.data.id)))
            .subscribe(with: self, onNext: { weakSelf, result in
                weakSelf.detailResultRelay.accept(Content(type: contentType, data: result))
            }, onError: { weakSelf, error in
                weakSelf.apiErrorRelay.accept(())
            })
            .disposed(by: disposeBag)
    }
}
