//
//  BannerView.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 23/12/2024.
//

import UIKit

private enum Constants {
    static let height: CGFloat = 50.0
    static let horizontalInset: CGFloat = 16.0
}

final class BannerView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    init(message: String) {
        super.init(frame: .zero)
        setupUI(message: message)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func show(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Constants.height),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func dismiss() {
        removeFromSuperview()
    }
}

private extension BannerView {
    func setupUI(message: String) {
        backgroundColor = .red
        label.text = message
        addSubview(label)
        
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
