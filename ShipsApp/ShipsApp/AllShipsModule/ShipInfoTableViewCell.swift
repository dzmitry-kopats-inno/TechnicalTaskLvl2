//
//  ShipInfoTableViewCell.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 20/12/2024.
//

import UIKit

private enum Constants {
    static let imageViewSize: CGFloat = 80.0
    static let labelFont: UIFont = .systemFont(ofSize: 14)
    static let nameLabelFont: UIFont = .boldSystemFont(ofSize: 16)
    static let labelTextColor: UIColor = .gray
    static let contentViewCornerRadius: CGFloat = 16.0
    static let contentViewBorderWidth: CGFloat = 1.0
    static let contentViewBorderColor: UIColor = .lightGray
    static let cellPadding: CGFloat = 8.0
    static let verticalSpacing: CGFloat = 4.0
}

final class ShipInfoTableViewCell: UITableViewCell, Reusable {
    
    private let borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.contentViewCornerRadius
        view.layer.borderWidth = Constants.contentViewBorderWidth
        view.layer.borderColor = Constants.contentViewBorderColor.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let shipImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageViewSize / 2
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.nameLabelFont
        label.numberOfLines = 0
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.labelFont
        label.textColor = Constants.labelTextColor
        return label
    }()
    
    private let yearBuiltLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.labelFont
        label.textColor = Constants.labelTextColor
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        shipImageView.image = nil
        nameLabel.text = nil
        typeLabel.text = nil
        yearBuiltLabel.text = nil
    }
    
    func configure(with ship: ShipModel) {
        nameLabel.text = ship.name
        typeLabel.text = ship.type
        yearBuiltLabel.text = ship.yearBuilt.map { "Year Built: \($0)" }
        
        if let imageUrlString = ship.image, let imageUrl = URL(string: imageUrlString) {
            shipImageView.loadImage(from: imageUrl) { [weak self] in
                DispatchQueue.main.async {
                    self?.setNeedsLayout()
                }
            }
        } else {
            shipImageView.image = UIImage(named: "shipPlaceholder")
        }
    }
}

private extension ShipInfoTableViewCell {
    func setupUI() {
        contentView.addSubview(borderView)
        borderView.addSubview(shipImageView)
        borderView.addSubview(nameLabel)
        borderView.addSubview(typeLabel)
        borderView.addSubview(yearBuiltLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cellPadding),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cellPadding),
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellPadding),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.cellPadding),
            
            shipImageView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: Constants.cellPadding),
            shipImageView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            shipImageView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize),
            shipImageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize),
            shipImageView.topAnchor.constraint(greaterThanOrEqualTo: borderView.topAnchor, constant: Constants.cellPadding),
            shipImageView.bottomAnchor.constraint(greaterThanOrEqualTo: borderView.bottomAnchor, constant: -Constants.cellPadding),
            
            nameLabel.leadingAnchor.constraint(equalTo: shipImageView.trailingAnchor, constant: Constants.cellPadding),
            nameLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: Constants.cellPadding),
            nameLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -Constants.cellPadding),
            
            typeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.verticalSpacing),
            typeLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -Constants.cellPadding),
            
            yearBuiltLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            yearBuiltLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: Constants.verticalSpacing),
            yearBuiltLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -Constants.cellPadding),
            yearBuiltLabel.bottomAnchor.constraint(lessThanOrEqualTo: borderView.bottomAnchor, constant: -Constants.cellPadding)
        ])
    }
}
