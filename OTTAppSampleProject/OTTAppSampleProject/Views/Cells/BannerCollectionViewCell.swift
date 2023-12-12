//
//  BannerCollectionViewCell.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/12/23.
//

import UIKit
import SnapKit
import Kingfisher

class BannerCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "BannerCollectionViewCell"
    private let bannerImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(bannerImageView)
        addSubview(titleLabel)
        
        bannerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 14.0)
    }
    
    func configure(data: ContentData) {
        self.titleLabel.text = data.title
        self.bannerImageView.kf.setImage(with: URL(string: data.imageUrl))
    }
}
