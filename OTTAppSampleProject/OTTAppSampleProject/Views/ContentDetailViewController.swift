//
//  ContentDetailViewController.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/27/23.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxRelay

class ContentDetailViewController: UIViewController {
    private let previewImageView = UIImageView()
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let languageAndReleaseYearLabel = UILabel()
    private let overviewLabel = UILabel()
    private let originalTitleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let mediaTypeLabel = UILabel()
    private let titleLabelHeight: CGFloat = 50.0
    private let ratingLabelHeight: CGFloat = 30.0
    private let languageAndReleaseYearLabelHeight: CGFloat = 30.0
    private let overviewLabelHeight: CGFloat = 120.0
    private let originalTitleLabelHeight: CGFloat = 30.0
    private let releaseDateLabelHeight: CGFloat = 30.0
    private let mediaTypeLabelHeight: CGFloat = 30.0
    private var originalText: String? = nil
    private var overviewLabelHeightConstraint: Constraint?
    private let foldOverviewRelay = PublishRelay<Void>()
    private let unfoldOverviewRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setUI() {
        view.backgroundColor = .black
        view.addSubview(scrollView)
        view.addSubview(previewImageView)
        scrollView.addSubview(scrollContentView)
        [titleLabel, ratingLabel, languageAndReleaseYearLabel, overviewLabel, originalTitleLabel, releaseDateLabel, mediaTypeLabel].forEach { self.scrollContentView.addSubview($0)
        }
        
        previewImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(400.0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(previewImageView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview().inset(10.0)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.width.equalTo(scrollContentView)
            $0.height.equalTo(titleLabelHeight)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.width.equalTo(scrollContentView)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.height.equalTo(ratingLabelHeight)
        }
        
        languageAndReleaseYearLabel.snp.makeConstraints {
            $0.width.equalTo(scrollContentView)
            $0.top.equalTo(ratingLabel.snp.bottom)
            $0.height.equalTo(languageAndReleaseYearLabelHeight)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.width.equalTo(scrollContentView)
            $0.top.equalTo(languageAndReleaseYearLabel.snp.bottom)
            overviewLabelHeightConstraint = $0.height.equalTo(overviewLabelHeight).constraint
        }
        
        originalTitleLabel.snp.makeConstraints {
            $0.width.equalTo(scrollContentView)
            $0.top.equalTo(overviewLabel.snp.bottom)
            $0.height.equalTo(originalTitleLabelHeight)
        }
        
        releaseDateLabel.snp.makeConstraints {
            $0.width.equalTo(scrollContentView)
            $0.top.equalTo(originalTitleLabel.snp.bottom)
            $0.height.equalTo(releaseDateLabelHeight)
        }
        
        mediaTypeLabel.snp.makeConstraints {
            $0.width.equalTo(scrollContentView)
            $0.top.equalTo(releaseDateLabel.snp.bottom)
            $0.height.equalTo(mediaTypeLabelHeight)
            $0.bottom.equalTo(scrollView)
        }
        
        previewImageView.backgroundColor = .black
        scrollView.backgroundColor = .black
        scrollContentView.backgroundColor = .black
        
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 30.0, weight: .heavy)
        titleLabel.numberOfLines = 1
        
        ratingLabel.textColor = .white
        ratingLabel.textAlignment = .left
        ratingLabel.font = .boldSystemFont(ofSize: 15.0)
        ratingLabel.numberOfLines = 1
        
        languageAndReleaseYearLabel.textColor = .white
        languageAndReleaseYearLabel.textAlignment = .left
        languageAndReleaseYearLabel.font = .boldSystemFont(ofSize: 15.0)
        languageAndReleaseYearLabel.numberOfLines = 1
        
        overviewLabel.textColor = .white
        overviewLabel.textAlignment = .left
        overviewLabel.font = .systemFont(ofSize: 14.0)
        overviewLabel.numberOfLines = 3
        
        originalTitleLabel.textColor = .white
        originalTitleLabel.textAlignment = .left
        originalTitleLabel.font = .boldSystemFont(ofSize: 15.0)
        originalTitleLabel.numberOfLines = 1
        
        releaseDateLabel.textColor = .white
        releaseDateLabel.textAlignment = .left
        releaseDateLabel.font = .boldSystemFont(ofSize: 15.0)
        releaseDateLabel.numberOfLines = 1
        
        mediaTypeLabel.textColor = .white
        mediaTypeLabel.textAlignment = .left
        mediaTypeLabel.font = .boldSystemFont(ofSize: 15.0)
        mediaTypeLabel.numberOfLines = 1
    }
    
    func configure(content: Content) {
        let rating = Double(Int(content.data.rating*10))/10.0
        let originalLanguage = content.data.originalLanguage ?? "unknown"
        let releaseYear = content.data.releaseYear != nil ? " ∙ " + content.data.releaseYear! : ""
        
        titleLabel.text = (content.data.title != nil) ? content.data.title : content.data.name
        ratingLabel.text = "⭐️ \(rating) (\(content.data.ratingCount))"
        languageAndReleaseYearLabel.text = "\(originalLanguage)\(releaseYear)"
        overviewLabel.text = content.data.overview
        originalTitleLabel.text = "original_title".localized + ":   " + (content.data.originalTitle ?? content.data.originalName ?? "")
        releaseDateLabel.text = "release_date".localized + ":   " + (content.data.releaseDate ?? "")
        mediaTypeLabel.text = "media_type".localized + ":   " + (content.type?.rawValue.localized ?? "unknown".localized)
        previewImageView.kf.setImage(with: URL(string: content.data.previewImageUrl), completionHandler:  { [weak self] _ in
            self?.previewImageView.layoutIfNeeded()
        })
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.originalText = self.overviewLabel.text
            self.overviewLabel.replaceEllipsis(with: "더보기", eventRelay: self.unfoldOverviewRelay)
        }
    }
    
    private func bind() {
        unfoldOverviewRelay
            .asSignal()
            .emit(with: self) { weakSelf, _ in
                weakSelf.overviewLabel.text = weakSelf.originalText
                weakSelf.overviewLabel.numberOfLines = weakSelf.overviewLabel.maxNumberOfLines
                weakSelf.overviewLabelHeightConstraint?.deactivate()
                weakSelf.overviewLabel.snp.makeConstraints {
                    weakSelf.overviewLabelHeightConstraint = $0.height.equalTo(weakSelf.overviewLabel.maxHeight).constraint
                }
            }
            .disposed(by: disposeBag)
        
        foldOverviewRelay
            .asSignal()
            .emit(with: self) { weakSelf, _ in
            }
            .disposed(by: disposeBag)
    }
}
