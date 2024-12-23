//
//  UIImageView+Extension.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 20/12/2024.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL, completion: @escaping () -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self, let data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                completion()
            }
        }.resume()
    }
}
