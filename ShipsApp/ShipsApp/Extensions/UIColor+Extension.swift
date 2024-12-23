//
//  UIColor+Extension.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 23/12/2024.
//

import UIKit

extension UIColor {
    static var headerText: UIColor {
        dynamicColor(light: .black, dark: .white)
    }
    
    static var textFieldText: UIColor {
        dynamicColor(light: .black, dark: .white)
    }
    
    static var closeButtonTint: UIColor {
        dynamicColor(light: .black, dark: .white)
    }
    
    static var navigationBarBackground: UIColor {
        dynamicColor(light: .white, dark: .black)
    }
    
    static var navigationBarTitle: UIColor {
        dynamicColor(light: .black, dark: .white)
    }
}

private extension UIColor {
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
}
