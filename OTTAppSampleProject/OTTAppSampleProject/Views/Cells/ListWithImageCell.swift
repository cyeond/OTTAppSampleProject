//
//  ListOnlyImageCell.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/13/23.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift

class ListWithImageCell: UICollectionViewCell {
    static let identifier = "ListWithImageCell"
    let previewImageButton = UIButton()
    var disposeBag = DisposeBag()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func setUI() {
        addSubview(previewImageButton)
        
        previewImageButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        previewImageButton.clipsToBounds = true
        previewImageButton.layer.cornerRadius = 5.0
        previewImageButton.adjustsImageWhenHighlighted = false
    }
    
    func configure(data: ContentData) {
        previewImageButton.kf.setImage(with: URL(string: data.previewImageUrl), for: .normal, completionHandler: { [weak self] _ in
            self?.previewImageButton.layoutIfNeeded()
        })
    }
}
