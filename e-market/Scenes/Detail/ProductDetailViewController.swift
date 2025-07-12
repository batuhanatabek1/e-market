//
//  ProductDetailViewController.swift
//  e-market
//
//  Created by Batuhan Atabek on 12.07.2025.
//

import UIKit
import Kingfisher

class ProductDetailViewController: UIViewController {
    
    var product: Product?
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "arrow.left")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let favoriteStarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .systemYellow
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 22)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let bottomBarView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0, height: -2)
        v.layer.shadowRadius = 6
        return v
    }()
    
    private let priceTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Price:"
        lbl.textColor = .systemBlue
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let priceValueLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let priceStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let addToCartButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Add to Cart"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        configureWithProduct()
    }
    
    private func setupViews() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        imageView.addSubview(favoriteStarButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        
        view.addSubview(bottomBarView)
        bottomBarView.addSubview(priceStackView)
        bottomBarView.addSubview(addToCartButton)
        
        priceStackView.addArrangedSubview(priceTitleLabel)
        priceStackView.addArrangedSubview(priceValueLabel)
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 70),
            
            priceStackView.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 16),
            priceStackView.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            
            addToCartButton.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -16),
            addToCartButton.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            
            favoriteStarButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            favoriteStarButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            favoriteStarButton.widthAnchor.constraint(equalToConstant: 28),
            favoriteStarButton.heightAnchor.constraint(equalToConstant: 28),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    private func configureWithProduct() {
        guard let product = product else { return }
        nameLabel.text = product.name
        descriptionLabel.text = product.description
        titleLabel.text = product.name
        
        if let url = URL(string: product.image) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        
        let starImageName = product.isFavorite ? "star.fill" : "star"
        favoriteStarButton.setImage(UIImage(systemName: starImageName), for: .normal)
        favoriteStarButton.tintColor = product.isFavorite ? .systemYellow : .lightGray
        
        priceValueLabel.text = "\(product.price) ₺"
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addToCartTapped() {
        guard let product = product else { return }
        CoreDataManager.shared.saveCartProduct(product)
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
}
