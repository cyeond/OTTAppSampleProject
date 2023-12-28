//
//  ContentDetailViewController.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/27/23.
//

import UIKit
import SnapKit
import Kingfisher

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .black
        view.addSubview(previewImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(titleLabel)
        scrollContentView.addSubview(ratingLabel)
        scrollContentView.addSubview(languageAndReleaseYearLabel)
        scrollContentView.addSubview(overviewLabel)
        scrollContentView.addSubview(originalTitleLabel)
        scrollContentView.addSubview(releaseDateLabel)
        scrollContentView.addSubview(mediaTypeLabel)
        
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
            $0.edges.equalTo(0)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(titleLabelHeight + ratingLabelHeight + languageAndReleaseYearLabelHeight + overviewLabelHeight + originalTitleLabelHeight + releaseDateLabelHeight + mediaTypeLabelHeight + 65.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(scrollContentView.snp.horizontalEdges)
            $0.top.equalTo(scrollContentView.snp.top).inset(20.0)
            $0.height.equalTo(titleLabelHeight)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(scrollContentView.snp.horizontalEdges)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.height.equalTo(ratingLabelHeight)
        }
        
        languageAndReleaseYearLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(scrollContentView.snp.horizontalEdges)
            $0.top.equalTo(ratingLabel.snp.bottom)
            $0.height.equalTo(languageAndReleaseYearLabelHeight)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(scrollContentView.snp.horizontalEdges)
            $0.top.equalTo(languageAndReleaseYearLabel.snp.bottom)
            $0.height.equalTo(overviewLabelHeight)
        }
        
        originalTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(scrollContentView.snp.horizontalEdges)
            $0.top.equalTo(overviewLabel.snp.bottom)
            $0.height.equalTo(originalTitleLabelHeight)
        }
        
        releaseDateLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(scrollContentView.snp.horizontalEdges)
            $0.top.equalTo(originalTitleLabel.snp.bottom)
            $0.height.equalTo(releaseDateLabelHeight)
        }
        
        mediaTypeLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(scrollContentView.snp.horizontalEdges)
            $0.top.equalTo(releaseDateLabel.snp.bottom)
            $0.height.equalTo(mediaTypeLabelHeight)
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

    }
}
