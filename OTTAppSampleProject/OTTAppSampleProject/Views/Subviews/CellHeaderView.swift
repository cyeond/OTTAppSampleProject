//
//  CellHeaderView.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/13/23.
//

import UIKit
import SnapKit

enum HeaderType {
    case large
    case small
}

class CellHeaderView: UICollectionReusableView {
    static let identifier = "CellHeaderView"
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.textAlignment = .left
    }
    
    func configure(title: String, type: HeaderType = .large) {
        titleLabel.text = title
        switch type {
        case .small:
            titleLabel.font = .systemFont(ofSize: 13.0, weight: .heavy)
            titleLabel.textColor = UIColor(named: "customLightGray")
        case .large:
            titleLabel.font = .systemFont(ofSize: 20.0, weight: .heavy)
            titleLabel.textColor = .white
        }
    }
}
