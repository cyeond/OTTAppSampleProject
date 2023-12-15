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
    private let previewImageButton = UIButton()
    private let listImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(previewImageButton)
        
        previewImageButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        previewImageButton.clipsToBounds = true
        previewImageButton.layer.cornerRadius = 5.0
    }
    
    func configure(data: ContentData) {
        previewImageButton.kf.setImage(with: URL(string: data.previewImageUrl), for: .normal)
    }
}
