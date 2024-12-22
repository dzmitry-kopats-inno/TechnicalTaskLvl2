//
//  ShipEntity+CoreDataProperties.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 22/12/2024.
//
//

import Foundation
import CoreData


extension ShipEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShipEntity> {
        return NSFetchRequest<ShipEntity>(entityName: "ShipEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var image: String?
    @NSManaged public var name: String
    @NSManaged public var type: String?
    @NSManaged public var yearBuilt: Int64
    @NSManaged public var weightKg: Int64
    @NSManaged public var homePort: String?
    @NSManaged public var roles: NSObject?

}

extension ShipEntity : Identifiable {

}
