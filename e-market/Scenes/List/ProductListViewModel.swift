//
//  ProductListViewModel.swift
//  e-market
//
//  Created by Batuhan Atabek on 11.07.2025.
//

class ProductListViewModel {
    var products: [Product] = []
    private var allProducts: [Product] = []

    var onDataUpdated: (() -> Void)?

    func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                let favoriteIDs = CoreDataManager.shared.fetchFavoriteIDs()
                self.allProducts = products.map {
                    var p = $0
                    p.isFavorite = favoriteIDs.contains(p.id)
                    return p
                }
                self.products = self.allProducts
                self.onDataUpdated?()
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
        }
    }

    func filterProducts(by searchText: String) {
        if searchText.isEmpty {
            products = allProducts
        } else {
            products = allProducts.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        onDataUpdated?()
    }

    func updateFavorite(by productId: String, isFavorite: Bool) {
        if let product = allProducts.first(where: { $0.id == productId }) {
            saveOrRemoveFavorite(product: product, isFavorite: isFavorite)
        }
        if let index = allProducts.firstIndex(where: { $0.id == productId }) {
            allProducts[index].isFavorite = isFavorite
        }
        if let index = products.firstIndex(where: { $0.id == productId }) {
            products[index].isFavorite = isFavorite
        }
        onDataUpdated?()
    }

    private func saveOrRemoveFavorite(product: Product, isFavorite: Bool) {
        if isFavorite {
            CoreDataManager.shared.saveFavoriteProduct(product)
        } else {
            CoreDataManager.shared.removeFavoriteProduct(by: product.id)
        }
    }
}
