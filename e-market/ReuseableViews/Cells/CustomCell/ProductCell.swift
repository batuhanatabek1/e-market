//
//  ProductCell.swift
//  e-market
//
//  Created by Batuhan Atabek on 11.07.2025.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate: AnyObject {
    func didTapAddToCart(product: Product)
}

class ProductCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let priceLabel = UILabel()
    private let nameLabel = UILabel()
    private let addToCartButton = UIButton()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var product: Product?
    weak var delegate: ProductCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.05
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 4
        contentView.layer.masksToBounds = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 4
        contentView.addSubview(imageView)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        priceLabel.textColor = UIColor.systemBlue
        contentView.addSubview(priceLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 2
        contentView.addSubview(nameLabel)
        
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = UIColor.systemBlue
        addToCartButton.layer.cornerRadius = 6
        addToCartButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        contentView.addSubview(addToCartButton)
        
        contentView.addSubview(favoriteButton)
        
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            addToCartButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            addToCartButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            addToCartButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            addToCartButton.heightAnchor.constraint(equalToConstant: 36),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    func configure(with product: Product, delegate: ProductCellDelegate) {
        self.product = product
        self.delegate = delegate
        nameLabel.text = product.name
        priceLabel.text = "\(product.price) ₺"
        if let url = URL(string: product.image) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        updateFavoriteButton()
    }
    
    @objc private func favoriteTapped() {
        self.product?.isFavorite.toggle()
        updateFavoriteButton()
        
        NotificationCenter.default.post(name: .favoritesChanged, object: nil, userInfo: [
            "productId": product?.id ?? "",
            "isFavorite": product?.isFavorite ?? false
        ])
    }
    
    private func updateFavoriteButton() {
        guard let product = product else { return }
        let imageName = product.isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = product.isFavorite ? .systemYellow : .lightGray
    }
    
    @objc private func addToCartTapped() {
        guard let product = product else { return }
        self.delegate?.didTapAddToCart(product: product)
    }
}
