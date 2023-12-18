//
//  ContentNavigationView.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/12/23.
//

import UIKit
import RxSwift
import SnapKit

class ContentNavigationView: UIView {
    private let contentsButtonStackView = UIStackView()
    let tvContentButton = UIButton()
    let movieContentButton = UIButton()
    let contentTypeChangedSubject = PublishSubject<ContentType>()
    private let underlineView = UIView()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(contentsButtonStackView)
        contentsButtonStackView.axis = .horizontal
        contentsButtonStackView.distribution = .fillEqually
        contentsButtonStackView.backgroundColor = .black
        contentsButtonStackView.addArrangedSubview(tvContentButton)
        contentsButtonStackView.addArrangedSubview(movieContentButton)
        
        tvContentButton.addSubview(underlineView)
        
        tvContentButton.setTitle("TV", for: .normal)
        tvContentButton.setTitleColor(.white, for: .normal)
        tvContentButton.titleLabel?.font = .boldSystemFont(ofSize: 18.0)
        tvContentButton.tag = 1
        
        movieContentButton.setTitle("MOVIE", for: .normal)
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
            $0.centerX.equalTo(tvContentButton)
            $0.width.equalTo(50.0)
            $0.height.equalTo(5.0)
        }
    }
    
    private func bind() {
        tvContentButton.rx.tap
            .withUnretained(self)
            .observe(on: MainScheduler())
            .bind { _ in
                self.contentTypeChangedSubject.onNext(.tv)
            }
            .disposed(by: disposeBag)
        
        movieContentButton.rx.tap
            .withUnretained(self)
            .observe(on: MainScheduler())
            .bind { _ in
                self.contentTypeChangedSubject.onNext(.movie)
            }
            .disposed(by: disposeBag)
    }
}
