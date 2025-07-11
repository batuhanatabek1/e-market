//
//  MainTabBarController.swift
//  e-market
//
//  Created by Batuhan Atabek on 11.07.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
    }
    
    private func setupTabBar() {
        if let houseImage = UIImage(systemName: "house"),
           let resizedImage = houseImage.resized(to: CGSize(width: 35, height: 30)) {
            
            let productsVC = UINavigationController(rootViewController: ProductListViewController())
            let tabBarItem = UITabBarItem(title: nil, image: resizedImage.withRenderingMode(.alwaysTemplate), tag: 0)
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            productsVC.tabBarItem = tabBarItem
            
            viewControllers = [productsVC]
        }
    }
}
