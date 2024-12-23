//
//  Reusable.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 18/12/2024.
//

import Foundation

public protocol Reusable {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String { String(describing: self.self) }
}
