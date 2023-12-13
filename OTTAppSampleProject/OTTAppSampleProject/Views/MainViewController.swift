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
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        collectionView.register(HorizontalListCollectionViewCell.self, forCellWithReuseIdentifier: HorizontalListCollectionViewCell.identifier)
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
            case "HorizontalList":
                return self?.createHorizontalListSection()
            default:
                return self?.createHorizontalListSection()
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
    
    private func createHorizontalListSection() -> NSCollectionLayoutSection {
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
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .banner(let content):
                guard let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
                bannerCell.configure(data: content.data)
                return bannerCell
            case .horizontalList(let content):
                guard let horizontalListCell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalListCollectionViewCell.identifier, for: indexPath) as? HorizontalListCollectionViewCell else { return UICollectionViewCell() }
                horizontalListCell.configure(data: content.data)
                return horizontalListCell
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, IndexPath -> UICollectionReusableView? in
            switch self.dataSource?.snapshot().sectionIdentifiers[IndexPath.section].id {
            case "HorizontalList":
                guard let cellHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: IndexPath) as? CellHeaderView else { return nil }
                cellHeaderView.configure(title: "시청 중인 콘텐츠")
                return cellHeaderView
            default:
                return nil
            }
        }
    }
    
    private func setDataSourceSnapshot() {
        let bannerItems = DUMMY_ITEMS.map { Item.banner(Content(type: .tv, data: $0)) }
        let listItems = DUMMY_ITEMS.map { Item.horizontalList(Content(type: .tv, data: $0)) }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        snapshot.appendSections([Section(id: "Banner"), Section(id: "HorizontalList")])
        snapshot.appendItems(bannerItems, toSection: Section(id: "Banner"))
        snapshot.appendItems(listItems, toSection: Section(id: "HorizontalList"))
        
        dataSource?.apply(snapshot)
    }
}



let DUMMY_ITEMS = Array(1...10).map { ContentData(title: "TITLE \($0)", subtitle: "SUBTITLE \($0)", imageUrl: "https://source.unsplash.com/user/c_v_r/100x100")}
