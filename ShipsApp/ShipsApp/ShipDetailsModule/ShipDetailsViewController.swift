//
//  ShipDetailsViewController.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 18/12/2024.
//

import UIKit
import RxSwift
import RxCocoa

private enum Constants {
    static let imageSize: CGFloat = 200.0
    static let stackSpacing: CGFloat = 16.0
    static let stackHorizontalPadding: CGFloat = 16.0
    static let contentTopPadding: CGFloat = 60.0
    static let contentBottomPadding: CGFloat = 20.0
    static let closeButtonInset: CGFloat = 12.0
    static let placeholderImageName = "shipPlaceholder"
    static let offlineModeTitle = "No internet connection. You’re in Offline mode"
}

final class ShipDetailsViewController: UIViewController {
    private let viewModel: ShipDetailsViewModel
    private let disposeBag = DisposeBag()
    
    private var bannerView: BannerView?
    
    private let shipImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.imageSize / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nameLabel: BoldTextLabel = createBoldLabel(font: .boldSystemFont(ofSize: 24), textAlignment: .center)
    private lazy var typeLabel: BoldTextLabel = createBoldLabel()
    private lazy var yearBuiltLabel: BoldTextLabel = createBoldLabel()
    private lazy var weightKgLabel: BoldTextLabel = createBoldLabel()
    private lazy var homePortLabel: BoldTextLabel = createBoldLabel()
    private lazy var rolesLabel: BoldTextLabel = createBoldLabel(numberOfLines: 0)

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let icon = UIImage(systemName: "xmark")
        button.setImage(icon, for: .normal)
        button.tintColor = .closeButtonTint
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameLabel,
            typeLabel,
            yearBuiltLabel,
            weightKgLabel,
            homePortLabel,
            rolesLabel
        ])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var imageStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [shipImageView])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.alignment = .center
        return stack
    }()
    
    init(viewModel: ShipDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithData()
        bindNetworkStatus()
    }
}

private extension ShipDetailsViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageStackView)
        contentView.addSubview(mainStackView)
        
        setupLayout()
    }
    
    func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            imageStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.contentTopPadding),
            imageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: imageStackView.bottomAnchor, constant: Constants.stackSpacing),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.stackHorizontalPadding),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.stackHorizontalPadding),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Constants.contentBottomPadding),
            
            shipImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            shipImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.closeButtonInset),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.closeButtonInset)
        ])
    }
    
    func configureWithData() {
        let ship = viewModel.shipModel
        
        nameLabel.setBoldText(ship.name)
        typeLabel.setBoldText("Type: \(ship.type ?? "Unknown")")
        yearBuiltLabel.setBoldText("Year Built: \(ship.yearBuilt.map { String($0) } ?? "Unknown")")
        weightKgLabel.setBoldText("Weight: \(ship.weightKg.map { "\($0) kg" } ?? "Unknown")")
        homePortLabel.setBoldText("Home Port: \(ship.homePort ?? "Unknown")")
        rolesLabel.setBoldText("Roles: \(ship.roles?.joined(separator: ", ") ?? "No roles")")
        
        if let imageUrlString = ship.image, let imageUrl = URL(string: imageUrlString) {
            shipImageView.loadImage(from: imageUrl)
        } else {
            shipImageView.image = UIImage(named: Constants.placeholderImageName)
        }
    }
    
    func bindNetworkStatus() {
        viewModel.networkStatus
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isAvailable in
                guard let self else { return }
                if isAvailable {
                    self.bannerView?.dismiss()
                    self.bannerView = nil
                    animateCloseButton(up: true)
                } else if self.bannerView == nil {
                    self.bannerView = BannerView(message: Constants.offlineModeTitle)
                    self.bannerView?.show(in: self.view)
                    animateCloseButton(up: false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func animateCloseButton(up: Bool) {
        let yOffset: CGFloat = up ? 10 : 60

        UIView.animate(withDuration: 0.3, animations: {
            self.closeButton.transform = CGAffineTransform(translationX: 0, y: yOffset)
        })
    }
    
    @objc func handleClose() {
        bannerView?.dismiss()
        bannerView = nil
        animateCloseButton(up: true)
        dismiss(animated: true, completion: nil)
    }
    
    func createBoldLabel(
        font: UIFont = .systemFont(ofSize: 18),
        textColor: UIColor = .darkGray,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 1
    ) -> BoldTextLabel {
        BoldTextLabel(font: font, textColor: textColor, textAlignment: textAlignment, numberOfLines: numberOfLines)
    }
}
