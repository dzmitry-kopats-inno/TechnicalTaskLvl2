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
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        // TODO: - Change color
        activityIndicator.color = .gray
        return activityIndicator
    }()
    
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.loginButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8.0
        button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        button.isEnabled = false
        return button
    }()
    
    private let guestButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.guestButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8.0
        button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        button.isEnabled = true
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

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindActions()
        setupDismissKeyboardGesture()
    }
}

private extension LoginViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        
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
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func bindActions() {
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                startLoading()
                emailField.validate()
                passwordField.validate()
                
                viewModel.login(email: emailField.text, password: passwordField.text)
            })
            .disposed(by: disposeBag)
        
        guestButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                openAllShipsScreen(isGuestMode: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self else { return }
                stopLoading()
                showError(error)
            })
            .disposed(by: disposeBag)
        
        viewModel.success
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                stopLoading()
                openAllShipsScreen(isGuestMode: false)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            emailField.rx.text.orEmpty.map { !$0.isEmpty },
            passwordField.rx.text.orEmpty.map { !$0.isEmpty }
        )
        .map { $0 && $1 }
        .subscribe(onNext: { [weak self] isEnabled in
            guard let self else { return }
            updateButtonState(loginButton, isEnabled: isEnabled)
        })
        .disposed(by: disposeBag)
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
        updateButtonState(loginButton, isEnabled: false)
        updateButtonState(guestButton, isEnabled: false)
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        updateButtonState(loginButton, isEnabled: true)
        updateButtonState(guestButton, isEnabled: true)
    }
    
    func updateButtonState(_ button: UIButton, isEnabled: Bool) {
        button.isEnabled = isEnabled
        button.backgroundColor = isEnabled ? .systemBlue : .systemGray
    }
    
    func openAllShipsScreen(isGuestMode: Bool) {
        let networkService = AppNetworkManager()
        let networkServiceMonitor = NetworkMonitorServiceImplementation()
        let coreDataService = CoreDataServiceImplementation()
        let shipRepository = ShipsRepositoryImplementation(networkService: networkService,
                                                           coreDataService: coreDataService)
        
        let viewModel = AllShipsViewModel(
            networkMonitorService: networkServiceMonitor,
            shipsRepository: shipRepository
        )
        // TODO: - Use isGuestMode property
        let allShipsViewController = AllShipsViewController(viewModel: viewModel)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(allShipsViewController, animated: true)
        }
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
