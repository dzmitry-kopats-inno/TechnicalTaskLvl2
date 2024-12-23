//
//  UIViewController+Extension.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 20/12/2024.
//

import UIKit

extension UIViewController {
    func showError(_ error: Error) {
        let errorMessage: String
        if let appError = error as? AppError {
            errorMessage = appError.message
        } else {
            errorMessage = error.localizedDescription
        }
        
        let finalMessage = errorMessage.isEmpty ? "An unknown error occurred." : errorMessage
        
        let alert = UIAlertController(title: "Error", message: finalMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
