//
//  ListWithTextAndButtonCell.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/21/23.
//

import UIKit
import RxSwift
import RxRelay
import SnapKit

class ListWithTextAndButtonCell: UICollectionViewCell {
    static let identifier = "ListWithTextAndButtonCell"
    let cellAreaButtonWithText = UIButton()
    let rightButton = UIButton()
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
        addSubview(rightButton)
        addSubview(cellAreaButtonWithText)
        
        rightButton.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightButton.tintColor = UIColor(named: "customLightGray")
        
        cellAreaButtonWithText.setTitleColor(.white, for: .normal)
        cellAreaButtonWithText.contentHorizontalAlignment = .leading
        cellAreaButtonWithText.titleLabel?.font = .systemFont(ofSize: 15.0)
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(10.0)
        }
        
        cellAreaButtonWithText.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview()
            $0.trailing.equalTo(rightButton.snp.leading)
        }
    }
    
    func configure(text: String, buttonImage: UIImage? = nil) {
        cellAreaButtonWithText.setTitle(text, for: .normal)
        
        if let image = buttonImage {
            rightButton.setImage(image, for: .normal)
        }
    }
}
