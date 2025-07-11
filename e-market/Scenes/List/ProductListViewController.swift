//
//  ProductListViewController.swift
//  e-market
//
//  Created by Batuhan Atabek on 11.07.2025.
//

import UIKit

class ProductListViewController: UIViewController {
    private let viewModel = ProductListViewModel()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "E-Market"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .gray
        imageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        container.addSubview(imageView)
        textField.leftView = container
        textField.leftViewMode = .always

        return textField
    }()

    private let filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filters:"
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Select Filter", for: .normal)
        button.backgroundColor = UIColor(white: 0.9, alpha: 1)
        button.setTitleColor(.black , for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupCollectionView()
        observeFavoritesChanged()
        
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.fetchProducts()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func observeFavoritesChanged() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesChanged(_:)), name: .favoritesChanged, object: nil)
    }

    @objc private func handleFavoritesChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let productId = userInfo["productId"] as? String,
              let isFavorite = userInfo["isFavorite"] as? Bool else {
            return
        }
        viewModel.updateFavorite(by: productId, isFavorite: isFavorite)
        collectionView.reloadData()
    }

    private func setupViews() {
        searchField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        view.addSubview(searchField)
        view.addSubview(filterLabel)
        view.addSubview(filterButton)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),

            searchField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 36),

            filterLabel.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20),
            filterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            filterButton.centerYAnchor.constraint(equalTo: filterLabel.centerYAnchor),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 130),
            filterButton.heightAnchor.constraint(equalToConstant: 40),

            collectionView.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
    }

    @objc private func searchTextChanged(_ sender: UITextField) {
        let query = sender.text ?? ""
        viewModel.filterProducts(by: query)
    }
}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        let product = viewModel.products[indexPath.item]
        cell.configure(with: product)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let spacing: CGFloat = 10
        let totalHorizontalSpacing = (2 * padding) + spacing
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / 2
        let itemHeight = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.item]
        print(product.name)
    }
}
