//
//  ShipDetailsViewController.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 18/12/2024.
//

import UIKit

class ShipDetailsViewController: UIViewController {
    private let ship: ShipModel
    
    private enum Constants {
        static let imageSize: CGFloat = 200.0
        static let stackSpacing: CGFloat = 16.0
        static let stackHorizontalPadding: CGFloat = 16.0
        static let contentTopPadding: CGFloat = 20.0
        static let contentBottomPadding: CGFloat = 20.0
        static let closeButtonInset: CGFloat = 12.0
        static let placeholderImageName = "shipPlaceholder"
    }
    
    private let shipImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.imageSize / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = createLabel(font: .boldSystemFont(ofSize: 24), textAlignment: .center)
    private lazy var typeLabel: UILabel = createLabel()
    private lazy var yearBuiltLabel: UILabel = createLabel()
    private lazy var weightKgLabel: UILabel = createLabel()
    private lazy var homePortLabel: UILabel = createLabel()
    private lazy var rolesLabel: UILabel = createLabel(numberOfLines: 0)

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let icon = UIImage(systemName: "xmark")
        button.setImage(icon, for: .normal)
        button.tintColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            shipImageView,
            nameLabel,
            typeLabel,
            yearBuiltLabel,
            weightKgLabel,
            homePortLabel,
            rolesLabel
        ])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.alignment = .center
        return stack
    }()
    
    init(ship: ShipModel) {
        self.ship = ship
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithData()
    }
}

private extension ShipDetailsViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        setupLayout()
    }
    
    func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.contentTopPadding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.stackHorizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.stackHorizontalPadding),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Constants.contentBottomPadding),
            
            shipImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            shipImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.closeButtonInset),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.closeButtonInset)
        ])
    }
    
    func configureWithData() {
        nameLabel.text = ship.name
        typeLabel.text = "Type: \(ship.type ?? "Unknown")"
        yearBuiltLabel.text = "Year Built: \(ship.yearBuilt.map { String($0) } ?? "Unknown")"
        weightKgLabel.text = "Weight: \(ship.weightKg.map { "\($0) kg" } ?? "Unknown")"
        homePortLabel.text = "Home Port: \(ship.homePort ?? "Unknown")"
        rolesLabel.text = "Roles: \(ship.roles?.joined(separator: ", ") ?? "No roles")"
        
        if let imageUrlString = ship.image, let imageUrl = URL(string: imageUrlString) {
            shipImageView.loadImage(from: imageUrl)
        } else {
            shipImageView.image = UIImage(named: Constants.placeholderImageName)
        }
    }
    
    @objc func handleClose() {
        dismiss(animated: true, completion: nil)
    }
    
    func createLabel(
        font: UIFont = .systemFont(ofSize: 18),
        textColor: UIColor = .darkGray,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 1
    ) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        return label
    }
}
