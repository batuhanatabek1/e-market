//
//  Product.swift
//  e-market
//
//  Created by Batuhan Atabek on 11.07.2025.
//

struct Product: Codable {
    let id: String
    let name: String
    let price: String
    let image: String
    let description: String
    let category: String?
    
    var isFavorite: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id, name, price, image, description, category
    }
}
