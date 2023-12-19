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
        self.tabBar.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    }
    
    private func setViewControllers() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 1)
                
        self.setViewControllers([homeVC, searchVC], animated: true)
    }
}
