//
//  ListOnlyImageCell.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/13/23.
//

import UIKit
import SnapKit
import Kingfisher

class ListWithImageCell: UICollectionViewCell {
    static let identifier = "ListWithImageCell"
    private let listImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(listImageView)
        
        listImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        listImageView.clipsToBounds = true
        listImageView.layer.cornerRadius = 5.0
    }
    
    func configure(data: ContentData) {
        listImageView.kf.setImage(with: URL(string: data.imageUrl))
    }
}
