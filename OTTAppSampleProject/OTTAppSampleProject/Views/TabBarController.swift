//
//  TabBarController.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/19/23.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setViewControllers()
    }
    
    private func setUI() {
        self.tabBar.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .white
        self.tabBar.backgroundColor = UIColor(named: "customDarkGray")
    }
    
    private func setViewControllers() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "home".localized, image: UIImage(systemName: "house"), tag: 0)
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "search".localized, image: UIImage(systemName: "magnifyingglass"), tag: 1)
                
        self.setViewControllers([homeVC, searchVC], animated: true)
    }
}
