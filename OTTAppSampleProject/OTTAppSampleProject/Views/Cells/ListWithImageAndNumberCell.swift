//
//  ListWithImageAndNumber.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/13/23.
//

import UIKit
import SnapKit
import Kingfisher

enum NumberPosition {
    case top
    case middle
    case bottom
}

class ListWithImageAndNumberCell: UICollectionViewCell {
    static let identifier = "ListWithImageAndNumberCell"
    private let numberLabel = UILabel()
    private let listImageView = UIImageView()
    private let numberLabelHeightRatio: CGFloat = 0.4
    private var numberLabelConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(numberLabel)
        addSubview(listImageView)
        
        numberLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.35)
            $0.height.equalToSuperview().multipliedBy(numberLabelHeightRatio)
            numberLabelConstraint = $0.bottom.equalToSuperview().constraint
        }
        
        listImageView.snp.makeConstraints {
            $0.verticalEdges.trailing.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
        
        numberLabel.adjustsFontSizeToFitWidth = true
        numberLabel.textAlignment = .center
        numberLabel.layer.masksToBounds = false
        numberLabel.layer.shadowColor = UIColor.systemBlue.cgColor
        numberLabel.layer.shadowRadius = 4.0
        numberLabel.layer.shadowOffset = .init(width: 0, height: 2.0)
        numberLabel.layer.shadowOpacity = 0.8
        
        listImageView.clipsToBounds = true
        listImageView.layer.cornerRadius = 5.0
    }
    
    func configure(data: ContentData, number: Int, numberPosition: NumberPosition = .bottom) {
        let attributedText = NSAttributedString(
            string: String(number+1),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.strokeColor: UIColor.systemBlue,
                NSAttributedString.Key.strokeWidth: -2.0,
                NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 45)!
            ]
        )
        
        numberLabel.attributedText = attributedText
        listImageView.kf.setImage(with: URL(string: data.previewImageUrl))
        
        switch numberPosition {
        case .top:
            numberLabelConstraint?.update(inset: self.frame.height*(1.0-numberLabelHeightRatio))
        case .middle:
            numberLabelConstraint?.update(inset: self.frame.height*(1.0-numberLabelHeightRatio)/2.0)
        default:
            break
        }
    }
}
