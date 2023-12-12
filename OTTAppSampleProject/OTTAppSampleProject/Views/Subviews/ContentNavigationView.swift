//
//  ContentNavigationView.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/12/23.
//

import UIKit
import SnapKit

class ContentNavigationView: UIView {
    private let contentsButtonStackView = UIStackView()
    private let tvContentButton = UIButton()
    private let movieContentButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(contentsButtonStackView)
        contentsButtonStackView.axis = .horizontal
        contentsButtonStackView.distribution = .equalSpacing
        contentsButtonStackView.backgroundColor = .black
        contentsButtonStackView.addArrangedSubview(tvContentButton)
        contentsButtonStackView.addArrangedSubview(movieContentButton)
        
        tvContentButton.setTitle("TV", for: .normal)
        tvContentButton.setTitleColor(.white, for: .normal)
        tvContentButton.titleLabel?.font = .boldSystemFont(ofSize: 18.0)
        tvContentButton.tag = 1
        
        movieContentButton.setTitle("MOVIE", for: .normal)
        movieContentButton.setTitleColor(.white, for: .normal)
        movieContentButton.titleLabel?.font = .boldSystemFont(ofSize: 18.0)
        movieContentButton.tag = 2
        
        contentsButtonStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20.0)
        }
    }
}
