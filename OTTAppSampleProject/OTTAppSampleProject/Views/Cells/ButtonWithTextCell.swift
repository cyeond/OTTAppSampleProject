//
//  ButtonWithTextCell.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/26/23.
//

import UIKit
import SnapKit
import RxSwift

class ButtonWithTextCell: UICollectionViewCell {
    static let identifier = "ButtonWithTextCell"
    let cellButton = UIButton()
    
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
        addSubview(cellButton)
        
        cellButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cellButton.clipsToBounds = true
        cellButton.layer.cornerRadius = frame.height/2
        cellButton.backgroundColor = .systemBlue
        
        cellButton.titleLabel?.font = .boldSystemFont(ofSize: 14.0)
        cellButton.titleLabel?.textAlignment = .center
        cellButton.setTitleColor(.white, for: .normal)
    }
    
    func configure(text: String) {
        cellButton.setTitle(text, for: .normal)
    }
}
