//
//  ContentNavigationView.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/12/23.
//

import UIKit
import RxSwift
import SnapKit
import RxRelay

class ContentNavigationView: UIView {
    let contentTypeChangedRelay = PublishRelay<ContentType>()
    private let contentsButtonStackView = UIStackView()
    private let tvContentButton = UIButton()
    private let movieContentButton = UIButton()
    private let underlineView = UIView()
    private var underlineViewConstraint: Constraint?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.underlineViewConstraint?.update(inset: contentsButtonStackView.frame.width/4 - 25)
    }
    
    private func setUI() {
        addSubview(contentsButtonStackView)
        contentsButtonStackView.axis = .horizontal
        contentsButtonStackView.distribution = .fillEqually
        contentsButtonStackView.backgroundColor = .black
        contentsButtonStackView.addArrangedSubview(tvContentButton)
        contentsButtonStackView.addArrangedSubview(movieContentButton)
        
        tvContentButton.addSubview(underlineView)
        
        tvContentButton.setTitle("tv_content_title".localized, for: .normal)
        tvContentButton.setTitleColor(.white, for: .normal)
        tvContentButton.titleLabel?.font = .boldSystemFont(ofSize: 18.0)
        tvContentButton.tag = 1
        
        movieContentButton.setTitle("movie_content_title".localized, for: .normal)
        movieContentButton.setTitleColor(.white, for: .normal)
        movieContentButton.titleLabel?.font = .boldSystemFont(ofSize: 18.0)
        movieContentButton.tag = 2
        
        underlineView.backgroundColor = .white
        
        contentsButtonStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20.0)
        }
        
        underlineView.snp.makeConstraints {
            $0.bottom.equalTo(contentsButtonStackView).inset(5.0)
            $0.width.equalTo(50.0)
            $0.height.equalTo(5.0)
            self.underlineViewConstraint = $0.leading.equalToSuperview().constraint
        }
    }
    
    private func bind() {
        tvContentButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.contentTypeChangedRelay.accept(.tv)
                weakSelf.underlineViewConstraint?.update(inset: self.contentsButtonStackView.frame.width/4 - 25)
            }
            .disposed(by: disposeBag)
        
        movieContentButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.contentTypeChangedRelay.accept(.movie)
                weakSelf.underlineViewConstraint?.update(inset: self.contentsButtonStackView.frame.width*3/4 - 25)
            }
            .disposed(by: disposeBag)
    }
}
