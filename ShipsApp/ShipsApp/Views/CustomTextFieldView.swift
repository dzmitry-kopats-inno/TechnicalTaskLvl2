//
//  CustomTextFieldView.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 18/12/2024.
//

import UIKit
import RxSwift

private enum Constants {
    static let commonSpacing: CGFloat = 8.0
    static let cornerRadius: CGFloat = 8.0
    static let textFieldHeight: CGFloat = 40.0
}

enum CustomTextFieldType {
    case email
    case requiredText
}

final class CustomTextFieldView: UIView {
    // MARK: - Properties
    private let type: CustomTextFieldType
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    // MARK: - GUI Properties
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.font = .systemFont(ofSize: 14)
        textField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight).isActive = true
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter text",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label, textField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.commonSpacing
        return stackView
    }()

    // MARK: - Life cycle
    init(labelText: String, type: CustomTextFieldType = .requiredText, placeholder: String? = nil) {
        self.type = type
        super.init(frame: .zero)
        setupUI(labelText: labelText, placeholder: placeholder)
    }

    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Methods
    func setBorderColor(_ color: UIColor) {
        textField.layer.borderColor = color.cgColor
    }
    
    func validate() {
        guard let text = text, !text.isEmpty else {
            setBorderColor(.red)
            return
        }
        setBorderColor(.black)
    }
}

private extension CustomTextFieldView {
    func setupUI(labelText: String, placeholder: String?) {
        label.text = labelText

        if type == .email {
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
        }
        
        if let placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
        }

        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
