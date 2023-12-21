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
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString.init(string: "search_bar_placeholder".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "customLightGray") ?? UIColor.lightGray])
        searchBar.searchTextField.leftView?.tintColor = UIColor(named: "customLightGray")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        
        if let clearButton = searchBar.searchTextField.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = UIColor(named: "customLightGray")
            clearButton.titleLabel?.font = .boldSystemFont(ofSize: 18.0)
        }
        
        searchBar.snp.makeConstraints {
            $0.height.equalTo(30.0)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom)
        }
    }
    
    private func setCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.register(ListWithImageAndNumberCell.self, forCellWithReuseIdentifier: ListWithImageAndNumberCell.identifier)
        collectionView.register(ListWithTextAndButtonCell.self, forCellWithReuseIdentifier: ListWithTextAndButtonCell.identifier)
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
    
    private func createSuggestionCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, environment in
            switch self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex].id {
            default:
                return self?.createRisingContentsSection()
            }
        }, configuration: layoutConfig)
        
        suggestionCollectionLayout = layout
        
        return layout
    }
    
    private func createSearchHistoryCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, environment in
            switch self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex].id {
            default:
                return self?.createSearchHistorySection()
            }
        }, configuration: layoutConfig)
        
        searchHistoryCollectionLayout = layout
        
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
        group.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
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
                return listWithTextAndButtonCell
            default:
                return UICollectionViewCell()
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch self.dataSource?.snapshot().sectionIdentifiers[indexPath.section].id {
            case "Suggestion1":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "rising_contents".localized)
                return cellHeaderView
            case "SearchHistory":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "recent_searches".localized, type: .small)
                return cellHeaderView
            default:
                return nil
            }
        }
        
        var suggestionDataSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        var searchHistoryDataSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        suggestionDataSnapshot.appendSections([Section(id: "Suggestion1")])
        searchHistoryDataSnapshot.appendSections([Section(id: "SearchHistory")])
        
        self.dataSource?.apply(suggestionDataSnapshot)
        self.suggestionDataSnapshot = suggestionDataSnapshot
        self.searchHistoryDataSnapshot = searchHistoryDataSnapshot
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
                
                let suggestionItems = data.results.prefix(15).map { Item.listWithImageAndNumber(Content(type: .none, data: $0)) }
                
                suggestionDataSnapshot.appendItems(suggestionItems, toSection: Section(id: "Suggestion1"))
                
                weakSelf.suggestionDataSnapshot = suggestionDataSnapshot
                weakSelf.dataSource?.apply(suggestionDataSnapshot)
            }
            .disposed(by: disposeBag)
        
        viewModel.apiErrorRelay
            .asSignal()
            .emit(with: self) { weakSelf, data in
                
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
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.resignFirstResponder()
    }
    
    private func showSuggestionLayout() {
        if let snapshot = suggestionDataSnapshot {
            dataSource?.apply(snapshot)
        }
        setSuggestionCollectionViewLayout()
    }
    
    private func showSearchHistoryLayout() {
        if var snapshot = searchHistoryDataSnapshot {
            let searchHistoryItems = viewModel.testSearchHistory.map { Item.listWithTextAndButton($0) }
            
            snapshot.appendItems(searchHistoryItems)

            dataSource?.apply(snapshot)
        }
        setSearchHistoryCollectionViewLayout()
    }
}
