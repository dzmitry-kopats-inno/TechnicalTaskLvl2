//
//  BoldTextLabel.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 23/12/2024.
//

import UIKit

class BoldTextLabel: UILabel {
    init(
        font: UIFont = .systemFont(ofSize: 18),
        textColor: UIColor = .darkGray,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 1
    ) {
        super.init(frame: .zero)
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
    
    func setBoldText(_ boldText: String, regularText: String? = nil) {
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let regularAttributes: [NSAttributedString.Key: Any] = [.font: font as Any]
        
        let attributedString = NSMutableAttributedString(string: boldText, attributes: boldAttributes)
        if let regularText {
            attributedString.append(NSAttributedString(string: regularText, attributes: regularAttributes))
        }
        
        attributedText = attributedString
    }
    
    func setRegularText(_ text: String) {
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
