//
//  BannerCollectionViewCell.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/12/23.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift

class BannerCell: UICollectionViewCell {
    static let identifier: String = "BannerCell"
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    private let playButton = UIButton()
    let bannerImageButton = UIButton()
    var disposeBag = DisposeBag()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setGradientLayer(bannerImageButton)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func setUI() {
        addSubview(bannerImageButton)
        addSubview(playButton)
        addSubview(infoLabel)
        addSubview(titleLabel)
        
        bannerImageButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        playButton.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(15.0)
            $0.height.equalTo(35.0)
            $0.width.equalTo(120.0)
        }
        
        infoLabel.snp.makeConstraints {
            $0.height.equalTo(30.0)
            $0.horizontalEdges.equalToSuperview().inset(15.0)
            $0.bottom.equalTo(playButton.snp.top)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(30.0)
            $0.horizontalEdges.equalToSuperview().inset(15.0)
            $0.bottom.equalTo(infoLabel.snp.top)
        }
        
        bannerImageButton.clipsToBounds = true
        bannerImageButton.layer.cornerRadius = 10.0
        bannerImageButton.adjustsImageWhenHighlighted = false
        
        playButton.backgroundColor = .systemBlue
        playButton.clipsToBounds = true
        playButton.layer.cornerRadius = 5.0
        playButton.setTitle("play_button_title".localized, for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .heavy)
        
        infoLabel.textColor = .white
        infoLabel.font = .boldSystemFont(ofSize: 14.0)
        
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 18.0)
    }
    
    func configure(data: ContentData) {
        let rating = Double(Int(data.rating*10))/10.0
        let originalLanguage = data.originalLanguage != nil ? " ∙ " + data.originalLanguage! : ""
        let releaseDate = data.releaseDate != nil ? " ∙ " + data.releaseDate! : ""
        
        titleLabel.text = (data.title != nil) ? data.title : data.name
        infoLabel.text = "⭐️ \(rating)\(originalLanguage)\(releaseDate)"
        bannerImageButton.kf.setImage(with: URL(string: data.previewImageUrl), for: .normal, completionHandler:  { [weak self] _ in
            self?.bannerImageButton.layoutIfNeeded()
        })
    }
    
    private func setGradientLayer(_ view: UIView) {
        guard view.tag != 1000 else { return }
        
        let colors: [CGColor] = [UIColor.clear.cgColor, UIColor.black.cgColor]
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = [0.3, 1.0]
        gradientLayer.opacity = 0.6
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.tag = 1000
    }
}
