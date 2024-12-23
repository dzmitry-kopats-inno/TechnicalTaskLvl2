//
//  ShipModel.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 18/12/2024.
//

struct ShipModel: Codable {
    let id: String
    let image: String?
    let name: String
    let type: String?
    let yearBuilt: Int?
    let weightKg: Int?
    let homePort: String?
    let roles: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case image
        case name
        case type
        case yearBuilt = "year_built"
        case weightKg = "mass_kg"
        case homePort = "home_port"
        case roles
    }
    
    init(_ entity: ShipEntity) {
        self.id = entity.id
        self.image = entity.image
        self.name = entity.name
        self.type = entity.type
        self.yearBuilt = Int(entity.yearBuilt)
        self.weightKg = Int(entity.weightKg)
        self.homePort = entity.homePort
        self.roles = entity.roles as? [String] ?? []
    }
}
