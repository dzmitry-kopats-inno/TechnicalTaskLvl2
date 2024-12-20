//
//  ShipModel.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 18/12/2024.
//

struct ShipModel: Codable {
    let id: String
    let image: String
    let name: String
    let type: String
    let year: Int
    let weightKg: Int
    let homePort: String
    let roles: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case image
        case name
        case type
        case year = "year_built"
        case weightKg = "mass_kg"
        case homePort = "home_port"
        case roles
    }
}
