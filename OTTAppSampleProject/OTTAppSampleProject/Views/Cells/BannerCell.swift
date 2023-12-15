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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setGradientLayer(bannerImageView)
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
    
    private func setGradientLayer(_ view: UIView) {
        guard view.tag != 1000 else { return }
        
        let colors: [CGColor] = [UIColor.clear.cgColor, UIColor.black.cgColor]
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.opacity = 0.6
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.tag = 1000
    }
}
