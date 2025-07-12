//
//  FavoritesViewController.swift
//  e-market
//
//  Created by Batuhan Atabek on 12.07.2025.
//

import UIKit

class FavoritesViewController: UIViewController {
    private let viewModel: FavoriteProductsViewModelProtocol = FavoriteProductsViewModel()

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorites"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupCollectionView()
        observeFavoritesChanged()
        viewModel.loadFavorites()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func observeFavoritesChanged() {
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesChanged), name: .favoritesChanged, object: nil)
    }

    @objc private func favoritesChanged() {
        viewModel.loadFavorites()
        collectionView.reloadData()
    }

    private func setupViews() {
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),

            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: "EmptyCell")
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(viewModel.favoriteProducts.count, 1)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.favoriteProducts.isEmpty {
            if let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath) as? EmptyCell {
                return emptyCell
            }
            return UICollectionViewCell()
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        let product = viewModel.favoriteProducts[indexPath.item]
        cell.configure(with: product, delegate: self)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel.favoriteProducts.isEmpty {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height - 150)
        }

        let padding: CGFloat = 16
        let spacing: CGFloat = 10
        let totalHorizontalSpacing = (2 * padding) + spacing
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / 2
        let itemHeight = itemWidth * 1.6
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.favoriteProducts.isEmpty else { return }
        let product = viewModel.favoriteProducts[indexPath.item]
        let detailVC = ProductDetailViewController()
        detailVC.product = product
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension FavoritesViewController: ProductCellDelegate {
    func didTapAddToCart(product: Product) {
        CoreDataManager.shared.saveCartProduct(product)
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
}
