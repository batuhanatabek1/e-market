//
//  NetworkManager.swift
//  e-market
//
//  Created by Batuhan Atabek on 11.07.2025.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        let url = Constant.baseUrl
        
        AF.request(url).validate().responseDecodable(of: [Product].self) { response in
            switch response.result {
            case .success(let products):
                completion(.success(products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
