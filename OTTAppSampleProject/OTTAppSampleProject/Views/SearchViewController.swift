//
//  SearchViewController.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/19/23.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
    
    private func setUI() {
        view.backgroundColor = .black
        view.addSubview(searchBar)
        
        searchBar.barTintColor = .clear
        searchBar.searchTextField.backgroundColor = UIColor(named: "customDarkGray")
        searchBar.searchTextField.font = .boldSystemFont(ofSize: 15.0)
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.tintColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString.init(string: "search_bar_placeholder".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "customLightGray") ?? UIColor.lightGray])
        searchBar.searchTextField.leftView?.tintColor = UIColor(named: "customLightGray")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        
        if let clearButton = searchBar.searchTextField.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = UIColor(named: "customLightGray")
            clearButton.titleLabel?.font = .boldSystemFont(ofSize: 18.0)
        }
        
        searchBar.snp.makeConstraints {
            $0.height.equalTo(30.0)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        searchBar.searchTextField.rx.controlEvent(.editingDidBegin)
            .asSignal()
            .emit(with: self) { weakSelf, value in
                weakSelf.startEditing()
            }
            .disposed(by: disposeBag)
        
        searchBar.searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .asSignal()
            .emit(with: self) { weakSelf, value in
                weakSelf.search()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .asSignal()
            .emit(with: self) { weakSelf, value in
                weakSelf.cancelEditing()
            }
            .disposed(by: disposeBag)
    }
    
    private func startEditing() {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.searchTextField.becomeFirstResponder()
    }
    
    private func cancelEditing() {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.resignFirstResponder()
        searchBar.searchTextField.text = ""
    }
    
    private func search() {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.resignFirstResponder()
    }
}
