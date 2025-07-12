//
//  CartViewController.swift
//  e-market
//
//  Created by Batuhan Atabek on 12.07.2025.
//

import UIKit

class CartViewController: UIViewController {
    private var cartProducts: [CartProduct] = []
    private let tableView = UITableView()
    private let totalLabel = UILabel()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupHeaderView()
        setupTableView()
        setupBottomView()
        loadCart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCart()
    }

    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12)
        ])
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(CartCell.self, forCellReuseIdentifier: "CartCell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupBottomView() {
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .white
        view.addSubview(bottomView)

        let totalTextLabel = UILabel()
        totalTextLabel.text = "Total:"
        totalTextLabel.font = UIFont.boldSystemFont(ofSize: 20)
        totalTextLabel.textColor = .systemBlue
        totalTextLabel.translatesAutoresizingMaskIntoConstraints = false

        totalLabel.font = UIFont.systemFont(ofSize: 18)
        totalLabel.textColor = .black
        totalLabel.translatesAutoresizingMaskIntoConstraints = false

        let completeButton = UIButton(type: .system)
        completeButton.setTitle("Complete", for: .normal)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        completeButton.backgroundColor = .systemBlue
        completeButton.layer.cornerRadius = 12
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.addTarget(self, action: #selector(completeTapped), for: .touchUpInside)

        bottomView.addSubview(totalTextLabel)
        bottomView.addSubview(totalLabel)
        bottomView.addSubview(completeButton)

        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 70),

            totalTextLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            totalTextLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),

            totalLabel.leadingAnchor.constraint(equalTo: totalTextLabel.leadingAnchor),
            totalLabel.topAnchor.constraint(equalTo: totalTextLabel.bottomAnchor, constant: 4),

            completeButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            completeButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            completeButton.widthAnchor.constraint(equalToConstant: 140),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func loadCart() {
        cartProducts = CoreDataManager.shared.fetchCartProducts()
        updateTotal()
        tableView.reloadData()
    }

    private func updateTotal() {
        let total = cartProducts.reduce(0.0) { total, product in
            let cleanedPrice = (product.price ?? "").replacingOccurrences(of: ",", with: ".")
            let priceValue = Double(cleanedPrice) ?? 0.0
            return total + (priceValue * Double(product.quantity))
        }
        totalLabel.text = "Total: \(Int(total)) ₺"
    }

    @objc private func completeTapped() {
        print("Sepet tamamlandı!")
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate, CartCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = cartProducts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.configure(with: product)
        cell.delegate = self
        return cell
    }

    func didChangeQuantity(for product: CartProduct, to newQuantity: Int) {
        CoreDataManager.shared.updateCartProductQuantity(product, to: newQuantity)
        loadCart()
    }
    
    func didRemoveProduct(_ product: CartProduct) {
        CoreDataManager.shared.removeCartProduct(by: product.id ?? "")
        loadCart()
    }
}
