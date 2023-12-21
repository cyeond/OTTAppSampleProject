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
    private let textLabel = UILabel()
    private let cellButton = UIButton()
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .black
        addSubview(cellButton)
        addSubview(textLabel)
        
        cellButton.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cellButton.tintColor = UIColor(named: "customLightGray")
        
        textLabel.textColor = .white
        textLabel.textAlignment = .left
        textLabel.font = .systemFont(ofSize: 15.0)
        
        cellButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(10.0)
        }
        
        textLabel.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview()
            $0.trailing.equalTo(cellButton.snp.leading)
        }
    }
    
    func configure(text: String, buttonImage: UIImage? = nil) {
        textLabel.text = text
        
        if let image = buttonImage {
            cellButton.setImage(image, for: .normal)
        }
    }
}
