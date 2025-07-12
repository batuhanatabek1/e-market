//
//  CoreDataManager.swift
//  e-market
//
//  Created by Batuhan Atabek on 11.07.2025.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    func saveFavoriteProduct(_ product: Product) {
        let entity = FavoriteProduct(context: context)
        entity.id = product.id
        entity.name = product.name
        entity.price = product.price
        entity.image = product.image
        entity.productDescription = product.description
        entity.isFavorite = true
        
        saveContext()
    }
    
    func removeFavoriteProduct(by id: String) {
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let result = try? context.fetch(request), let objectToDelete = result.first {
            context.delete(objectToDelete)
            saveContext()
        }
    }
    
    func fetchFavoriteIDs() -> Set<String> {
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        if let result = try? context.fetch(request) {
            return Set(result.compactMap { $0.id })
        }
        return []
    }
    
    func fetchFavoriteProducts() -> [FavoriteProduct] {
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        let result = try? context.fetch(request)
        return result ?? []
    }
    
    func saveCartProduct(_ product: Product) {
        let request: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", product.id)
        
        if let result = try? context.fetch(request), let existing = result.first {
            existing.quantity += 1
        } else {
            let entity = CartProduct(context: context)
            entity.id = product.id
            entity.name = product.name
            entity.image = product.image
            entity.price = product.price
            entity.quantity = 1
        }
        saveContext()
    }
    
    func updateCartProductQuantity(_ product: CartProduct, to newQuantity: Int) {
        product.quantity = Int64(newQuantity)
        saveContext()
    }

    func fetchCartProducts() -> [CartProduct] {
        let request: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        let result = try? context.fetch(request)
        return result ?? []
    }

    func removeCartProduct(by id: String) {
        let request: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let result = try? context.fetch(request), let toDelete = result.first {
            context.delete(toDelete)
            saveContext()
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("CoreData save error: \(error)")
            }
        }
    }
}
