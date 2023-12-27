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
        let homeNavController = UINavigationController()
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "home".localized, image: UIImage(systemName: "house"), tag: 0)
        homeNavController.setViewControllers([homeViewController], animated: true)
        homeNavController.setNavigationBarHidden(true, animated: false)
        
        let searchNavController = UINavigationController()
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: "search".localized, image: UIImage(systemName: "magnifyingglass"), tag: 1)
        searchNavController.setViewControllers([searchViewController], animated: true)
        searchNavController.setNavigationBarHidden(true, animated: false)
                
        self.setViewControllers([homeNavController, searchNavController], animated: true)
    }
}
