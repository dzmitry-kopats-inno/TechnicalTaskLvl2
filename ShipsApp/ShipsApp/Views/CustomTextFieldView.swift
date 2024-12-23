//
//  CustomTextFieldView.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 18/12/2024.
//

import UIKit
import RxSwift
import RxCocoa

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
    private let type: CustomTextFieldType
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private(set) var textField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.font = .systemFont(ofSize: 14)
        textField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight).isActive = true
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

    init(labelText: String, type: CustomTextFieldType = .requiredText, placeholder: String? = nil) {
        self.type = type
        super.init(frame: .zero)
        
        setBorderColor(.textFieldText)
        setupUI(labelText: labelText, placeholder: placeholder)
    }

    required init?(coder: NSCoder) {
        nil
    }
    
    func validate() {
        guard let text = text, !text.isEmpty else {
            setBorderColor(.red)
            return
        }
        setBorderColor(.textFieldText)
    }
}

private extension CustomTextFieldView {
    func setBorderColor(_ color: UIColor) {
        textField.layer.borderColor = color.cgColor
    }
    
    func setupUI(labelText: String, placeholder: String?) {
        label.text = labelText
        textField.textColor = .textFieldText

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
        
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension Reactive where Base: CustomTextFieldView {
    var text: ControlProperty<String?> {
        base.textField.rx.text
    }
}
