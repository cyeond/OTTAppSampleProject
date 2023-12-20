//
//  HomeViewController.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/8/23.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

class HomeViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private var tvDataSnapshot: NSDiffableDataSourceSnapshot<Section, Item>?
    private var movieDataSnapshot: NSDiffableDataSourceSnapshot<Section, Item>?
    private let contentNavigationView = ContentNavigationView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let refreshControl = UIRefreshControl()
    private let blackCoverView = UIView()
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setCollectionView()
        setDataSource()
        bind()
    }
    
    private func setUI() {
        view.backgroundColor = .black
        view.addSubview(contentNavigationView)
        view.addSubview(collectionView)
        view.addSubview(blackCoverView)
        
        blackCoverView.backgroundColor = .black
        refreshControl.tintColor = .clear
        
        contentNavigationView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50.0)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(contentNavigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        blackCoverView.snp.makeConstraints {
            $0.edges.equalTo(collectionView.snp.edges)
        }
    }
    
    private func setCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.refreshControl = self.refreshControl
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        collectionView.register(ListWithImageCell.self, forCellWithReuseIdentifier: ListWithImageCell.identifier)
        collectionView.register(ListWithImageAndTitleCell.self, forCellWithReuseIdentifier: ListWithImageAndTitleCell.identifier)
        collectionView.register(ListWithImageAndNumberCell.self, forCellWithReuseIdentifier: ListWithImageAndNumberCell.identifier)
        collectionView.register(CellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellHeaderView.identifier)
        collectionView.setCollectionViewLayout(createCollectionViewLayout(), animated: true)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfig.interSectionSpacing = 30.0
        
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, environment in
            switch self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex].id {
            case "TVList1", "MovieList1":
                return self?.createList1Section()
            case "TVList2", "MovieList2":
                return self?.createList2Section()
            case "TVList3", "MovieList3":
                return self?.createList3Section()
            case "TVList4", "MovieList4":
                return self?.createList4Section()
            default:
                // "Banner" section
                return self?.createBannerSection()
            }
        }, configuration: layoutConfig)
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(450.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 5.0, bottom: 0, trailing: 5.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        return section
    }
    
    private func createList1Section() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        header.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 10.0)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(200.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createList2Section() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        header.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 10.0)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(150.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createList3Section() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        header.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 10.0)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .absolute(150.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createList4Section() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        header.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 10.0)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .absolute(150.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .banner(let content):
                guard let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as? BannerCell else { return UICollectionViewCell() }
                bannerCell.configure(data: content.data)
                return bannerCell
            case .listWithImageAndTitle(let content):
                guard let listWithTitleAndImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ListWithImageAndTitleCell.identifier, for: indexPath) as? ListWithImageAndTitleCell else { return UICollectionViewCell() }
                listWithTitleAndImageCell.configure(data: content.data)
                return listWithTitleAndImageCell
            case .listWithImage(let content):
                guard let listWithImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ListWithImageCell.identifier, for: indexPath) as? ListWithImageCell else { return UICollectionViewCell()}
                listWithImageCell.configure(data: content.data)
                return listWithImageCell
            case .listWithImageAndNumber(let content):
                guard let listWithImageAndNumberCell = collectionView.dequeueReusableCell(withReuseIdentifier: ListWithImageAndNumberCell.identifier, for: indexPath) as? ListWithImageAndNumberCell else { return UICollectionViewCell() }
                listWithImageAndNumberCell.configure(data: content.data, number: indexPath.row)
                return listWithImageAndNumberCell
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch self.dataSource?.snapshot().sectionIdentifiers[indexPath.section].id {
            case "TVList1":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "실시간 방영 중")
                return cellHeaderView
            case "TVList2":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "인기 TOP 20")
                return cellHeaderView
            case "TVList3":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "평점이 높은 콘텐츠")
                return cellHeaderView
            case "TVList4":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "유명 TV 프로그램")
                return cellHeaderView
            case "MovieList1":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "현재 상영 중")
                return cellHeaderView
            case "MovieList2":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "인기 TOP 20")
                return cellHeaderView
            case "MovieList3":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "평점이 높은 작품")
                return cellHeaderView
            case "MovieList4":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "유명 영화")
                return cellHeaderView
            default:
                return nil
            }
        }
        
        var tvSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        var movieSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        tvSnapshot.appendSections([Section(id: "Banner"), Section(id: "TVList1"), Section(id: "TVList2"), Section(id: "TVList3"), Section(id: "TVList4")])
        movieSnapshot.appendSections([Section(id: "Banner"), Section(id: "MovieList1"), Section(id: "MovieList2"), Section(id: "MovieList3"), Section(id: "MovieList4")])
        
        self.dataSource?.apply(tvSnapshot)
        self.tvDataSnapshot = tvSnapshot
        self.movieDataSnapshot = movieSnapshot
    }
    
    private func bind() {
        viewModel.tvResultsRelay
            .asSignal()
            .emit(with: self) { weakSelf, results in
                guard var snapshot = weakSelf.tvDataSnapshot, results.count == 5 else { return }
                
                let bannerItems = results[0].results.map { Item.banner(Content(type: .tv, data: $0)) }
                let list1Items = results[1].results.map { Item.listWithImageAndTitle(Content(type: .tv, data: $0)) }
                let list2Items = results[2].results.map { Item.listWithImageAndNumber(Content(type: .tv, data: $0)) }
                let list3Items = results[3].results.map { Item.listWithImage(Content(type: .tv, data: $0)) }
                let list4Items = results[4].results.map { Item.listWithImage(Content(type: .tv, data: $0)) }
                
                snapshot.appendItems(bannerItems, toSection: Section(id: "Banner"))
                snapshot.appendItems(list1Items, toSection: Section(id: "TVList1"))
                snapshot.appendItems(list2Items, toSection: Section(id: "TVList2"))
                snapshot.appendItems(list3Items, toSection: Section(id: "TVList3"))
                snapshot.appendItems(list4Items, toSection: Section(id: "TVList4"))
                
                weakSelf.dataSource?.apply(snapshot)
                
                weakSelf.endRefreshing()
            }
            .disposed(by: disposeBag)
        
        viewModel.movieResultsRelay
            .asSignal()
            .emit(with: self) { weakSelf, results in
                guard var snapshot = weakSelf.movieDataSnapshot, results.count == 5 else { return }
                
                let bannerItems = results[0].results.map { Item.banner(Content(type: .movie, data: $0)) }
                let list1Items = results[1].results.map { Item.listWithImageAndTitle(Content(type: .movie, data: $0)) }
                let list2Items = results[2].results.map { Item.listWithImageAndNumber(Content(type: .movie, data: $0)) }
                let list3Items = results[3].results.map { Item.listWithImage(Content(type: .movie, data: $0)) }
                let list4Items = results[4].results.map { Item.listWithImage(Content(type: .movie, data: $0)) }
                
                snapshot.appendItems(bannerItems, toSection: Section(id: "Banner"))
                snapshot.appendItems(list1Items, toSection: Section(id: "MovieList1"))
                snapshot.appendItems(list2Items, toSection: Section(id: "MovieList2"))
                snapshot.appendItems(list3Items, toSection: Section(id: "MovieList3"))
                snapshot.appendItems(list4Items, toSection: Section(id: "MovieList4"))
                
                weakSelf.dataSource?.apply(snapshot)
                
                weakSelf.endRefreshing()
            }
            .disposed(by: disposeBag)
        
        contentNavigationView.contentTypeChangedSubject.asObservable()
            .withUnretained(self)
            .bind { weakSelf, type in
                weakSelf.blackCoverView.isHidden = false
                weakSelf.viewModel.currentContentType = type
                weakSelf.viewModel.getResultsData()
            }
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.blackCoverView.isHidden = false
                weakSelf.viewModel.getResultsData()
            }
            .disposed(by: disposeBag)
        
        contentNavigationView.contentTypeChangedSubject.onNext(.tv)
    }
    
    private func endRefreshing() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: false)
        refreshControl.endRefreshing()
        Observable.just(()).delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.blackCoverView.isHidden = true
            }
            .disposed(by: disposeBag)
    }
}
