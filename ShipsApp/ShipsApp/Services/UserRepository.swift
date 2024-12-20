//
//  UserRepository.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 20/12/2024.
//

import Foundation

protocol UserRepository {
    func fetchUserPassword(email: String) -> String?
}

final class InMemoryUserRepository: UserRepository {
    private let users: [String: String] = [
        "admin@ad.min": "admin",
        "user@gmail.com": "password123",
        "help@help.com": "help123"
    ]
    
    func fetchUserPassword(email: String) -> String? {
        users[email]
    }
}
