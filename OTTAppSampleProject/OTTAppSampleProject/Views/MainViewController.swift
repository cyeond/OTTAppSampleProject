//
//  MainViewController.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/8/23.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    private let contentNavigationView = ContentNavigationView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setCollectionView()
        setDataSource()
        setDataSourceSnapshot()
    }
    
    private func setUI() {
        view.backgroundColor = .black
        view.addSubview(contentNavigationView)
        view.addSubview(collectionView)
        
        contentNavigationView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50.0)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(contentNavigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func setCollectionView() {
        collectionView.backgroundColor = .black
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
            case "Banner":
                return self?.createBannerSection()
            case "List1":
                return self?.createList1Section()
            case "List2":
                return self?.createList2Section()
            case "List3":
                return self?.createList3Section()
            default:
                return self?.createList1Section()
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
        header.contentInsets = .init(top: 0, leading: 5.0, bottom: 0, trailing: 5.0)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(100.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 5.0, bottom: 0, trailing: 5.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createList2Section() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        header.contentInsets = .init(top: 0, leading: 5.0, bottom: 0, trailing: 5.0)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(150.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 5.0, bottom: 0, trailing: 5.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createList3Section() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        header.contentInsets = .init(top: 0, leading: 5.0, bottom: 0, trailing: 5.0)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .absolute(150.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 5.0, bottom: 0, trailing: 5.0)
        
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
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, IndexPath -> UICollectionReusableView? in
            switch self.dataSource?.snapshot().sectionIdentifiers[IndexPath.section].id {
            case "List1":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: IndexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "시청 중인 콘텐츠")
                return cellHeaderView
            case "List2":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: IndexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "인기 TOP 20 콘텐츠")
                return cellHeaderView
            case "List3":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: IndexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "새로 나온 콘텐츠")
                return cellHeaderView
            default:
                return nil
            }
        }
    }
    
    private func setDataSourceSnapshot() {
        let bannerItems = Constants.DUMMY_ITEMS.map { Item.banner(Content(type: .tv, data: $0)) }
        let list1Items = Constants.DUMMY_ITEMS.map { Item.listWithImageAndTitle(Content(type: .tv, data: $0)) }
        let list2Items = Constants.DUMMY_ITEMS.map { Item.listWithImageAndNumber(Content(type: .tv, data: $0)) }
        let list3Items = Constants.DUMMY_ITEMS.map { Item.listWithImage(Content(type: .tv, data: $0)) }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        snapshot.appendSections([Section(id: "Banner"), Section(id: "List1"), Section(id: "List2"), Section(id: "List3")])
        snapshot.appendItems(bannerItems, toSection: Section(id: "Banner"))
        snapshot.appendItems(list1Items, toSection: Section(id: "List1"))
        snapshot.appendItems(list2Items, toSection: Section(id: "List2"))
        snapshot.appendItems(list3Items, toSection: Section(id: "List3"))
        
        dataSource?.apply(snapshot)
    }
}
