//
//  LoginViewController.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 17/12/2024.
//

import UIKit
import RxSwift
import RxCocoa

private enum Constants {
    static let commonSpacing: CGFloat = 16.0
    static let commonInset: CGFloat = 24.0
    static let buttonHeight: CGFloat = 50.0
    static let stackViewTopInset: CGFloat = 60.0
    static let titleText = "Welcome to the Ships Information project"
    static let emailFieldLabel = "Enter your email"
    static let passwordFieldLabel = "Enter your password"
    static let emailPlaceholder = "Email"
    static let passwordPlaceholder = "Password"
    static let loginButtonTitle = "Login"
    static let guestButtonTitle = "Login as a guest"
}

final class LoginViewController: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - GUI Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.titleText
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let emailField = CustomTextFieldView(labelText: Constants.emailFieldLabel,
                                                 type: .email,
                                                 placeholder: Constants.emailPlaceholder)
    private let passwordField = CustomTextFieldView(labelText: Constants.passwordFieldLabel,
                                                    type: .requiredText,
                                                    placeholder: Constants.passwordPlaceholder)

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.loginButtonTitle, for: .normal)
        button.backgroundColor = .systemGray4
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        return button
    }()
    
    private let guestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.guestButtonTitle, for: .normal)
        button.backgroundColor = .systemGray4
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailField,
            passwordField,
            loginButton,
            guestButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.commonSpacing
        return stackView
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindActions()
        setupDismissKeyboardGesture()
    }
}

// MARK: - UI Setup
private extension LoginViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.commonInset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.commonInset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.commonInset),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.stackViewTopInset),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.commonInset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.commonInset),
        ])
    }
    
    func bindActions() {
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                emailField.validate()
                passwordField.validate()
                
                // TODO: - Handle action
                debugPrint("Login tapped")
                if let email = emailField.text, let password = passwordField.text {
                    debugPrint("Email: \(email), Password: \(password)")
                }
            })
            .disposed(by: disposeBag)
        
        guestButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                // TODO: - Handle action
                debugPrint("Guest login tapped")
            })
            .disposed(by: disposeBag)
    }
    
    func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
