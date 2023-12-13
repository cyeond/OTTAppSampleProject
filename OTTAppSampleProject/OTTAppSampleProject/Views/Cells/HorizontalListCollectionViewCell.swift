//
//  HorizontalListCollectionViewCell.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/13/23.
//

import UIKit
import SnapKit
import Kingfisher

class HorizontalListCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "HorizontalListCollectionViewCell"
    private let listImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .black
        addSubview(listImageView)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5.0)
            $0.height.equalToSuperview().multipliedBy(0.1)
        }
        
        listImageView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-5.0)
        }
        
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 14.0)
        
        listImageView.clipsToBounds = true
        listImageView.layer.cornerRadius = 5.0
    }
    
    func configure(data: ContentData) {
        titleLabel.text = data.title
        listImageView.kf.setImage(with: URL(string: data.imageUrl))
    }
}
