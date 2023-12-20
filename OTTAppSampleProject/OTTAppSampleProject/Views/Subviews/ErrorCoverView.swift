//
//  ErrorCoverView.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/20/23.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

class ErrorCoverView: UIView {
    let refreshButtonTappedRelay = PublishRelay<Void>()
    private let errorLabel = UILabel()
    private let refreshButton = UIButton()
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
        self.backgroundColor = .black
        addSubview(errorLabel)
        addSubview(refreshButton)
        
        errorLabel.textColor = .white
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 1
        errorLabel.font = .systemFont(ofSize: 17.0, weight: .heavy)
        errorLabel.text = "load_failure_label_text".localized
        
        refreshButton.setTitle("reload".localized, for: .normal)
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .heavy)
        refreshButton.backgroundColor = .lightGray
        refreshButton.clipsToBounds = true
        refreshButton.layer.cornerRadius = 5.0
        
        errorLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20.0)
            $0.top.equalToSuperview().inset(200.0)
        }
        
        refreshButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(errorLabel.snp.bottom).offset(20.0)
            $0.height.equalTo(35.0)
            $0.width.equalTo(60.0)
        }
    }
    
    private func bind() {
        refreshButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.refreshButtonTappedRelay.accept(())
            }
            .disposed(by: disposeBag)
    }
}
