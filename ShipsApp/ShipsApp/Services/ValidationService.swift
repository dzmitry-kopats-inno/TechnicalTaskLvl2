//
//  ValidationService.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 20/12/2024.
//

import Foundation

protocol ValidationService {
    func isValid(_ text: String) -> Bool
}

final class EmailValidationService: ValidationService {
    func isValid(_ email: String) -> Bool {
        let emailRegEx = ".+@.+"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}
