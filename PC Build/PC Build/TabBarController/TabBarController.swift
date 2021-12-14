//
//  TabBarController.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - Properties
    let feedVC = FeedVC()
    let profileVC = ProfileVC()
    
    lazy var titles: [String] = [
        "Feed",
        "Profile"
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let _ = tabBar.items?.firstIndex(of: item) {}
    }
}

// MARK: - Setups

extension TabBarController {
    
    private func setupViews() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        view.backgroundColor = .white
        
        let feedNav = NavigationController(rootViewController: feedVC)
        let profileNav = NavigationController(rootViewController: profileVC)
        
        feedVC.tabBarItem.image = UIImage(named: "tabBar-feed")
        feedVC.tabBarItem.selectedImage = UIImage(named: "tabBar-feedFilled")
        
        profileVC.tabBarItem.image = UIImage(named: "tabBar-user")
        profileVC.tabBarItem.selectedImage = UIImage(named: "tabBar-userFilled")
        
        viewControllers = [feedNav, profileNav]
        
        for i in 0..<tabBar.items!.count {
            tabBar.items![i].imageInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -5.0, right: 0.0)
            tabBar.items![i].title = titles[i]
        }
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOffset = .zero
        tabBar.layer.shadowRadius = 1.0
        tabBar.layer.shadowOpacity = 0.3
    }
}
