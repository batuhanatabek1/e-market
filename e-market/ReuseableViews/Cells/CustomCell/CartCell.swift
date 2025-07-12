//
//  CartCell.swift
//  e-market
//
//  Created by Batuhan Atabek on 12.07.2025.
//
import UIKit

protocol CartCellDelegate: AnyObject {
    func didChangeQuantity(for product: CartProduct, to newQuantity: Int)
    func didRemoveProduct(_ product: CartProduct)
}

class CartCell: UITableViewCell {
    weak var delegate: CartCellDelegate?
    private var product: CartProduct?

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stepperLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.textAlignment = .center
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(white: 0.9, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(white: 0.9, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with product: CartProduct) {
        self.product = product
        nameLabel.text = product.name
        priceLabel.text = "\(product.price ?? "")₺"
        stepperLabel.text = "\(product.quantity)"
    }

    private func setupUI() {
        self.selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)

        let stepperStack = UIStackView(arrangedSubviews: [minusButton, stepperLabel, plusButton])
        stepperStack.axis = .horizontal
        stepperStack.spacing = 0
        stepperStack.distribution = .fillEqually
        stepperStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stepperStack)

        minusButton.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(increase), for: .touchUpInside)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: stepperStack.leadingAnchor, constant: -12),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            stepperStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stepperStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stepperStack.widthAnchor.constraint(equalToConstant: 130),
            stepperStack.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    @objc private func increase() {
        guard let product else { return }
        let newQty = Int(product.quantity) + 1
        delegate?.didChangeQuantity(for: product, to: newQty)
    }

    @objc private func decrease() {
        guard let product else { return }
        if product.quantity > 1 {
            let newQty = product.quantity - 1
            delegate?.didChangeQuantity(for: product, to: Int(newQty))
        } else {
            delegate?.didRemoveProduct(product)
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        }
    }
}
