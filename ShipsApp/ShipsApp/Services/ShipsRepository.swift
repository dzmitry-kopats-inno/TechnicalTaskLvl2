//
//  ShipsRepository.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 20/12/2024.
//

import CoreData
import RxSwift

protocol ShipsRepository {
    var error: Observable<AppError> { get }
    
    func fetchShips() -> Observable<[ShipModel]>
    func saveShips(_ ships: [ShipModel])
    func deleteShip(_ ship: ShipModel)
}

final class ShipsRepositoryImplementation: ShipsRepository {
    private let errorSubject = PublishSubject<AppError>()
    private let networkService: NetworkService
    private let coreDataService: CoreDataService
    private let disposeBag = DisposeBag()
    
    var error: Observable<AppError> {
        errorSubject.asObservable()
    }
    
    init(networkService: NetworkService, coreDataService: CoreDataService) {
        self.networkService = networkService
        self.coreDataService = coreDataService
        
        coreDataService.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self else { return }
                errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchShips() -> Observable<[ShipModel]> {
        return networkService.request(endpoint: Endpoint.ships)
            .do(onNext: { [weak self] ships in
                guard let self else { return }
                coreDataService.saveShips(ships)
            })
            .catch { [weak self] error in
                guard let self else { return Observable.empty() }
                errorSubject.onNext(AppError(message: "Failed to fetch ships: \(error.localizedDescription)"))
                return Observable.empty()
            }
    }

    func saveShips(_ ships: [ShipModel]) {
        coreDataService.saveShips(ships)
    }
    
    func deleteShip(_ ship: ShipModel) {
        coreDataService.deleteShip(ship)
    }
}
