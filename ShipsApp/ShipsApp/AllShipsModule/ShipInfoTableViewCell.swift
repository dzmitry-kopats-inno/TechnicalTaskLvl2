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
    static let cellPadding: CGFloat = 16.0
    static let verticalSpacing: CGFloat = 4.0
}

final class ShipInfoTableViewCell: UITableViewCell, Reusable {
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
    
    func configure(with ship: ShipModel) {
        nameLabel.text = ship.name
        typeLabel.text = ship.type
        yearBuiltLabel.text = ship.yearBuilt.map { "Year Built: \($0)" }
        
        if let imageUrlString = ship.image, let imageUrl = URL(string: imageUrlString) {
            shipImageView.loadImage(from: imageUrl)
        }
    }
}

private extension ShipInfoTableViewCell {
    func setupUI() {
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.layer.borderWidth = Constants.contentViewBorderWidth
        contentView.layer.borderColor = Constants.contentViewBorderColor.cgColor
        contentView.clipsToBounds = true
        
        contentView.addSubview(shipImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(yearBuiltLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            shipImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cellPadding),
            shipImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shipImageView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize),
            shipImageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize),
            
            nameLabel.leadingAnchor.constraint(equalTo: shipImageView.trailingAnchor, constant: Constants.cellPadding),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellPadding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cellPadding),
            
            typeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.verticalSpacing),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cellPadding),
            
            yearBuiltLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            yearBuiltLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: Constants.verticalSpacing),
            yearBuiltLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cellPadding),
            yearBuiltLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.cellPadding)
        ])
    }
}
