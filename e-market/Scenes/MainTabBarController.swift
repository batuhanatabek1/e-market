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
        updateCartBadge()
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
    }
    
    private func setupTabBar() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge), name: .cartUpdated, object: nil)
        
        let iconSize = CGSize(width: 35, height: 30)
        let imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let productsVC = UINavigationController(rootViewController: ProductListViewController())
        if let houseImage = UIImage(systemName: "house")?.resized(to: iconSize) {
            productsVC.tabBarItem = UITabBarItem(
                title: nil,
                image: houseImage.withRenderingMode(.alwaysTemplate),
                selectedImage: nil
            )
            productsVC.tabBarItem.imageInsets = imageInsets
        }

        let cartVC = UINavigationController(rootViewController: CartViewController())
        if let cartImage = UIImage(systemName: "basket")?.resized(to: iconSize) {
            cartVC.tabBarItem = UITabBarItem(
                title: nil,
                image: cartImage.withRenderingMode(.alwaysTemplate),
                selectedImage: nil
            )
            cartVC.tabBarItem.imageInsets = imageInsets
        }

        let favoritesVC = FavoritesViewController()
        if let starImage = UIImage(systemName: "star")?.resized(to: iconSize) {
            favoritesVC.tabBarItem = UITabBarItem(
                title: nil,
                image: starImage.withRenderingMode(.alwaysTemplate),
                selectedImage: nil
            )
            favoritesVC.tabBarItem.imageInsets = imageInsets
        }

        viewControllers = [productsVC, cartVC, favoritesVC]
        tabBar.backgroundColor = .white
    }
    
    @objc private func updateCartBadge() {
        let cartItems = CoreDataManager.shared.fetchCartProducts()
        let uniqueCount = cartItems.count

        if let tabItems = tabBar.items, tabItems.indices.contains(1) {
            let cartTab = tabItems[1]
            cartTab.badgeColor = .red
            cartTab.setBadgeTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            cartTab.badgeValue = uniqueCount > 0 ? "\(uniqueCount)" : nil
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .cartUpdated, object: nil)
    }
}
