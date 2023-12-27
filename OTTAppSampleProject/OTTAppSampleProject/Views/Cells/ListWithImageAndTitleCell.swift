//
//  HorizontalListCollectionViewCell.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/13/23.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift

class ListWithImageAndTitleCell: UICollectionViewCell {
    static let identifier: String = "ListWithImageAndTitleCell"
    private let titleLabel = UILabel()
    let listImageButton = UIButton()
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
        backgroundColor = .black
        addSubview(listImageButton)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5.0)
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        
        listImageButton.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-5.0)
        }
        
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 14.0)
        titleLabel.adjustsFontSizeToFitWidth = true
        
        listImageButton.clipsToBounds = true
        listImageButton.layer.cornerRadius = 5.0
        listImageButton.adjustsImageWhenHighlighted = false
    }
    
    func configure(data: ContentData) {
        titleLabel.text = (data.title != nil) ? data.title : data.name
        listImageButton.kf.setImage(with: URL(string: data.previewImageUrl), for: .normal, completionHandler:  { [weak self] _ in
            self?.listImageButton.layoutIfNeeded()
        })
    }
}
