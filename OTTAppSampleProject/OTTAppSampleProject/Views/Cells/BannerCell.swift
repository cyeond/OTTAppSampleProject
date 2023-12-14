//
//  BannerCollectionViewCell.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/12/23.
//

import UIKit
import SnapKit
import Kingfisher

class BannerCell: UICollectionViewCell {
    static let identifier: String = "BannerCell"
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
            $0.height.equalToSuperview().multipliedBy(0.1)
            $0.leading.bottom.equalToSuperview().inset(15.0)
        }
        
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 20.0)
        
        bannerImageView.clipsToBounds = true
        bannerImageView.layer.cornerRadius = 10.0
    }
    
    func configure(data: ContentData) {
        self.titleLabel.text = (data.title != nil) ? data.title : data.name
        self.bannerImageView.kf.setImage(with: URL(string: data.previewImageUrl))
    }
}
