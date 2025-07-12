//
//  FavoriteProductsViewModel.swift
//  e-market
//
//  Created by Batuhan Atabek on 12.07.2025.
//

import Foundation

protocol FavoriteProductsViewModelProtocol: AnyObject {
    var onFavoritesChanged: (() -> Void)? { get set }
    var favoriteProducts: [Product] { get }

    func loadFavorites()
    func numberOfItems() -> Int
    func product(at indexPath: IndexPath) -> Product
}

class FavoriteProductsViewModel: FavoriteProductsViewModelProtocol {
    
    var onFavoritesChanged: (() -> Void)?
    
    private(set) var favoriteProducts: [Product] = [] {
        didSet {
            onFavoritesChanged?()
        }
    }

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFavoritesChanged),
            name: .favoritesChanged,
            object: nil
        )
        loadFavorites()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .favoritesChanged, object: nil)
    }

    func loadFavorites() {
        let coreDataFavorites = CoreDataManager.shared.fetchFavoriteProducts()
        favoriteProducts = coreDataFavorites.map {
            Product(
                id: $0.id ?? "",
                name: $0.name ?? "",
                price: $0.price ?? "0",
                image: $0.image ?? "",
                description: $0.productDescription ?? "",
                category: nil,
                isFavorite: true
            )
        }
    }

    @objc private func handleFavoritesChanged() {
        loadFavorites()
    }

    func numberOfItems() -> Int {
        favoriteProducts.count
    }

    func product(at indexPath: IndexPath) -> Product {
        return favoriteProducts[indexPath.item]
    }
}
