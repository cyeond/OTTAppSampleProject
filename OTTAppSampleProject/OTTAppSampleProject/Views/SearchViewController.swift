//
//  SearchViewController.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/19/23.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {
    private let viewModel = SearchViewModel()
    private let searchBar = UISearchBar()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private var suggestionCollectionLayout: UICollectionViewCompositionalLayout?
    private var suggestionDataSnapshot: NSDiffableDataSourceSnapshot<Section, Item>?
    private var searchHistoryCollectionLayout: UICollectionViewCompositionalLayout?
    private var searchHistoryDataSnapshot: NSDiffableDataSourceSnapshot<Section, Item>?
    private var searchResultCollectionLayout: UICollectionViewCompositionalLayout?
    private var searchResultDataSnapshot: NSDiffableDataSourceSnapshot<Section, Item>?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setCollectionView()
        setDataSource()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.resignFirstResponder()
    }
    
    private func setUI() {
        view.backgroundColor = .black
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        searchBar.barTintColor = .clear
        searchBar.searchTextField.backgroundColor = UIColor(named: "customDarkGray")
        searchBar.searchTextField.font = .boldSystemFont(ofSize: 15.0)
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.tintColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString.init(string: "search_bar_placeholder".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "customLightGray") ?? UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)])
        searchBar.searchTextField.leftView?.tintColor = UIColor(named: "customLightGray")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        
        if let clearButton = searchBar.searchTextField.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = UIColor(named: "customLightGray")
            clearButton.titleLabel?.font = .boldSystemFont(ofSize: 18.0)
        }
        
        searchBar.snp.makeConstraints {
            $0.height.equalTo(36.0)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(15.0)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom).inset(-5.0)
        }
    }
    
    private func setCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.register(ListWithImageAndNumberCell.self, forCellWithReuseIdentifier: ListWithImageAndNumberCell.identifier)
        collectionView.register(ListWithTextAndButtonCell.self, forCellWithReuseIdentifier: ListWithTextAndButtonCell.identifier)
        collectionView.register(ListWithImageCell.self, forCellWithReuseIdentifier: ListWithImageCell.identifier)
        collectionView.register(ButtonWithTextCell.self, forCellWithReuseIdentifier: ButtonWithTextCell.identifier)
        collectionView.register(CellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellHeaderView.identifier)
        setSuggestionCollectionViewLayout()
    }
    
    private func setSuggestionCollectionViewLayout() {
        if let suggestionCollectionLayout = self.suggestionCollectionLayout {
            collectionView.setCollectionViewLayout(suggestionCollectionLayout, animated: false)
        } else {
            collectionView.setCollectionViewLayout(createSuggestionCollectionViewLayout(), animated: false)
        }
    }
    
    private func setSearchHistoryCollectionViewLayout() {
        if let searchHistoryCollectionLayout = self.searchHistoryCollectionLayout {
            collectionView.setCollectionViewLayout(searchHistoryCollectionLayout, animated: false)
        } else {
            collectionView.setCollectionViewLayout(createSearchHistoryCollectionViewLayout(), animated: false)
        }
    }
    
    private func setSearchResultCollectionViewLayout() {
        if let searchResultCollectionLayout = self.searchResultCollectionLayout {
            collectionView.setCollectionViewLayout(searchResultCollectionLayout, animated: false)
        } else {
            collectionView.setCollectionViewLayout(createSearchResultCollectionViewLayout(), animated: false)
        }
    }
    
    private func createSuggestionCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, environment in
            switch self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex].id {
            case "SuggestedKeywords":
                return self?.createSuggestedKeywordsSection()
            default:
                // "RisingContents"
                return self?.createRisingContentsSection()
            }
        }, configuration: layoutConfig)
        
        suggestionCollectionLayout = layout
        
        return layout
    }
    
    private func createSearchHistoryCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, environment in
            return self?.createSearchHistorySection()
        }, configuration: layoutConfig)
        
        searchHistoryCollectionLayout = layout
        
        return layout
    }
    
    private func createSearchResultCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, environment in
            return self?.createSearchResultSection()
        }, configuration: layoutConfig)
        
        searchResultCollectionLayout = layout
        
        return layout
    }
    
    private func createRisingContentsSection() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        header.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 10.0)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 10.0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .absolute(380.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createSuggestedKeywordsSection() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        header.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 10.0)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 10.0, trailing: 10.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createSearchHistorySection() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        header.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 10.0)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 10.0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 10.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createSearchResultSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.contentInsets = .init(top: 10.0, leading: 0, bottom: 0, trailing: 10.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10.0, leading: 0, bottom: 20.0, trailing: 0)
        
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .listWithImageAndNumber(let content):
                guard let listWithImageAndNumberCell = collectionView.dequeueReusableCell(withReuseIdentifier: ListWithImageAndNumberCell.identifier, for: indexPath) as? ListWithImageAndNumberCell else { return UICollectionViewCell()}
                listWithImageAndNumberCell.configure(data: content.data, number: indexPath.row, numberPosition: .middle)
                return listWithImageAndNumberCell
            case .listWithTextAndButton(let text):
                guard let listWithTextAndButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: ListWithTextAndButtonCell.identifier, for: indexPath) as? ListWithTextAndButtonCell else { return UICollectionViewCell()}
                listWithTextAndButtonCell.configure(text: text)
                listWithTextAndButtonCell.cellAreaButtonWithText.rx.tap
                    .asSignal()
                    .emit(with: self) { weakSelf, _ in
                        weakSelf.viewModel.searchHistoryCellTappedRelay.accept(text)
                    }
                    .disposed(by: listWithTextAndButtonCell.disposeBag)
                listWithTextAndButtonCell.rightButton.rx.tap
                    .asSignal()
                    .emit(with: self) { weakSelf, _ in
                        weakSelf.viewModel.deleteSearchHistoryCellRelay.accept(text)
                    }
                    .disposed(by: listWithTextAndButtonCell.disposeBag)
                return listWithTextAndButtonCell
            case .listWithImage(let content):
                guard let listWithImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ListWithImageCell.identifier, for: indexPath) as? ListWithImageCell else { return UICollectionViewCell()}
                listWithImageCell.configure(data: content.data)
                return listWithImageCell
            case .buttonWithText(let text):
                guard let buttonWithTextCell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonWithTextCell.identifier, for: indexPath) as? ButtonWithTextCell else { return UICollectionViewCell() }
                buttonWithTextCell.configure(text: text)
                buttonWithTextCell.cellButton.rx.tap
                    .asSignal()
                    .emit(with: self) { weakSelf, _ in
                        weakSelf.viewModel.suggestedKeywordTappedRelay.accept(text)
                    }
                    .disposed(by: buttonWithTextCell.disposeBag)
                return buttonWithTextCell
            default:
                return UICollectionViewCell()
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch self.dataSource?.snapshot().sectionIdentifiers[indexPath.section].id {
            case "RisingContents":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "rising_contents".localized)
                return cellHeaderView
            case "SuggestedKeywords":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "suggested_keywords".localized, type: .small)
                return cellHeaderView
            case "SearchHistory":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "recent_searches".localized, type: .small)
                return cellHeaderView
            case "SearchResult":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                return cellHeaderView
            default:
                return nil
            }
        }
        
        var suggestionDataSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        var searchHistoryDataSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        var searchResultDataSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        suggestionDataSnapshot.appendSections([Section(id: "RisingContents"), Section(id: "SuggestedKeywords")])
        searchHistoryDataSnapshot.appendSections([Section(id: "SearchHistory")])
        searchResultDataSnapshot.appendSections([Section(id: "SearchResult")])
        
        self.dataSource?.apply(suggestionDataSnapshot)
        self.suggestionDataSnapshot = suggestionDataSnapshot
        self.searchHistoryDataSnapshot = searchHistoryDataSnapshot
        self.searchResultDataSnapshot = searchResultDataSnapshot
    }
    
    private func bind() {
        searchBar.searchTextField.rx.controlEvent(.editingDidBegin)
            .asSignal()
            .emit(with: self) { weakSelf, value in
                weakSelf.startEditing()
            }
            .disposed(by: disposeBag)
        
        searchBar.searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .asSignal()
            .emit(with: self) { weakSelf, value in
                weakSelf.search()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .asSignal()
            .emit(with: self) { weakSelf, value in
                weakSelf.cancelEditing()
            }
            .disposed(by: disposeBag)
     
        viewModel.suggestionResultRelay
            .asSignal()
            .emit(with: self) { weakSelf, data in
                guard var suggestionDataSnapshot = weakSelf.suggestionDataSnapshot else { return }
                
                let suggestionItems = data.results.prefix(15).map {
                    let type: ContentType? = ContentType(rawValue: $0.mediaType ?? "")
                    return Item.listWithImageAndNumber(Content(type: type, data: $0))
                }
                let keywordItems = Constants.SUGGESTED_KEYWORDS.map { Item.buttonWithText($0) }
                
                suggestionDataSnapshot.appendItems(suggestionItems, toSection: Section(id: "RisingContents"))
                suggestionDataSnapshot.appendItems(keywordItems, toSection: Section(id: "SuggestedKeywords"))
                
                weakSelf.suggestionDataSnapshot = suggestionDataSnapshot
                weakSelf.dataSource?.apply(suggestionDataSnapshot)
            }
            .disposed(by: disposeBag)
        
        viewModel.searchResultRelay
            .asSignal()
            .emit(with: self) { weakSelf, data in
                weakSelf.showSearchResultLayout(contents: data.results)
            }
            .disposed(by: disposeBag)
        
        viewModel.apiErrorRelay
            .asSignal()
            .emit(with: self) { weakSelf, _ in
                
            }
            .disposed(by: disposeBag)
        
        viewModel.searchHistoryCellTappedRelay
            .asSignal()
            .emit(with: self) { weakSelf, text in
                weakSelf.searchBar.text = text
                weakSelf.search()
            }
            .disposed(by: disposeBag)
        
        viewModel.deleteSearchHistoryCellRelay
            .asSignal()
            .emit(with: self) { weakSelf, text in
                Storage.deleteToArray(key: "searchHistory", value: text)
                weakSelf.reloadSearchHistoryData()
            }
            .disposed(by: disposeBag)
        
        viewModel.suggestedKeywordTappedRelay
            .asSignal()
            .emit(with: self) { weakSelf, text in
                weakSelf.searchBar.text = text
                weakSelf.search()
            }
            .disposed(by: disposeBag)
        
        viewModel.getSuggestionData()
    }
    
    private func startEditing() {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.searchTextField.becomeFirstResponder()
        showSearchHistoryLayout()
    }
    
    private func cancelEditing() {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.resignFirstResponder()
        searchBar.searchTextField.text = ""
        showSuggestionLayout()
    }
    
    private func search() {
        guard let text = searchBar.text else { return }
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.resignFirstResponder()
        viewModel.getSearchData(text: text)
        Storage.insertToArray(key: "searchHistory", value: text)
    }
    
    private func showSuggestionLayout() {
        if let snapshot = suggestionDataSnapshot {
            dataSource?.apply(snapshot)
        }
        setSuggestionCollectionViewLayout()
    }
    
    private func showSearchHistoryLayout() {
        reloadSearchHistoryData()
        setSearchHistoryCollectionViewLayout()
    }
    
    private func showSearchResultLayout(contents: [ContentData]) {
        if var snapshot = searchResultDataSnapshot {
            let searchResultItems = contents.map {
                let type: ContentType? = ContentType(rawValue: $0.mediaType ?? "")
                return Item.listWithImage(Content(type: type, data: $0))
            }
            
            snapshot.appendItems(searchResultItems, toSection: Section(id: "SearchResult"))

            dataSource?.apply(snapshot)
        }
        setSearchResultCollectionViewLayout()
    }
    
    private func reloadSearchHistoryData() {
        if var snapshot = searchHistoryDataSnapshot {
            let searchHistoryItems = Storage.searchHistory.map { Item.listWithTextAndButton($0) }
            
            snapshot.appendItems(searchHistoryItems, toSection: Section(id: "SearchHistory"))

            dataSource?.apply(snapshot)
        }
    }
}
