//
//  CoreDataService.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 20/12/2024.
//

import CoreData
import RxSwift

protocol CoreDataService {
    var error: Observable<AppError> { get }
    
    func fetchShips() -> Observable<[ShipModel]>
    func saveShips(_ ships: [ShipModel])
    func deleteShip(_ ship: ShipModel)
}

final class CoreDataServiceImplementation: CoreDataService {
    private let coreDataStack: CoreDataStack
    private let errorSubject = PublishSubject<AppError>()
    
    var error: Observable<AppError> {
        errorSubject.asObservable()
    }
    
    init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.coreDataStack = coreDataStack
    }
    
    func fetchShips() -> Observable<[ShipModel]> {
        let fetchRequest: NSFetchRequest<ShipEntity> = ShipEntity.fetchRequest()
        
        return Observable.create { observer in
            do {
                let shipEntities = try self.coreDataStack.context.fetch(fetchRequest)
                let ships = shipEntities.map { entity in
                    ShipModel(entity)
                }
                observer.onNext(ships)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func saveShips(_ ships: [ShipModel]) {
        for ship in ships {
            createShipEntity(ship)
        }
        
        saveContext(errorText: "Failed to save ships")
    }
    
    func deleteShip(_ ship: ShipModel) {
        let fetchRequest: NSFetchRequest<ShipEntity> = ShipEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", ship.id)
        
        do {
            let shipEntities = try coreDataStack.context.fetch(fetchRequest)
            if let entityToDelete = shipEntities.first {
                coreDataStack.context.delete(entityToDelete)
                
                saveContext(errorText: "Failed to delete ship")
            }
        } catch {
            let appError = AppError(message: "Failed to delete ship: \(error.localizedDescription)")
            errorSubject.onNext(appError)
        }
    }
}

private extension CoreDataServiceImplementation {
    func createShipEntity(_ ship: ShipModel) {
        let newShip = ShipEntity(context: coreDataStack.context)
        newShip.id = ship.id
        newShip.name = ship.name
        newShip.image = ship.image
        newShip.type = ship.type
        newShip.yearBuilt = Int64(ship.yearBuilt ?? 0)
        newShip.weightKg = Int64(ship.weightKg ?? 0)
        newShip.homePort = ship.homePort
        newShip.roles = ship.roles as? NSObject
    }
    
    func saveContext(errorText: String) {
        guard coreDataStack.context.hasChanges else { return }
        do {
            try coreDataStack.context.save()
        } catch {
            let appError = AppError(message: "\(errorText) - \(error.localizedDescription)")
            errorSubject.onNext(appError)
        }
    }
}
