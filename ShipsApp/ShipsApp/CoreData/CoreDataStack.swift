//
//  CoreDataStack.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 20/12/2024.
//

import CoreData
import RxSwift

private enum Constants {
    static let modelName = "ShipModel"
}

final class CoreDataStack {
    private let persistentContainer: NSPersistentContainer
    private let errorSubject = PublishSubject<AppError>()

    static let shared = CoreDataStack()
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var error: Observable<AppError> {
        errorSubject.asObservable()
    }
    
    private init(container: NSPersistentContainer = NSPersistentContainer(name: Constants.modelName)) {
        persistentContainer = container
        persistentContainer.loadPersistentStores { [weak self] _, error in
            guard let self else { return }
            if let error {
                errorSubject.onNext(AppError(message: error.localizedDescription))
            }
        }
    }
}
