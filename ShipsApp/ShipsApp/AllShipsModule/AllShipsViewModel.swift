//
//  AllShipsViewModel.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 18/12/2024.
//

import Foundation
import RxSwift

final class AllShipsViewModel {
    private let networkMonitorService: NetworkMonitorService
    private let shipsRepository: ShipsRepository
    private let shipsSubject = BehaviorSubject<[ShipModel]>(value: [])
    private let errorSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    
    var isGuestMode: Bool
    
    var ships: Observable<[ShipModel]> {
        shipsSubject.asObservable()
    }
    
    var error: Observable<Error> {
        errorSubject.asObservable()
    }
    
    var isNetworkAvailable: Observable<Bool> {
        networkMonitorService.isNetworkAvailable
    }
    
    init(
        networkMonitorService: NetworkMonitorService,
        shipsRepository: ShipsRepository,
        isGuestMode: Bool
    ) {
        self.networkMonitorService = networkMonitorService
        self.shipsRepository = shipsRepository
        self.isGuestMode = isGuestMode
        
        shipsRepository.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self else { return }
                errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchShips() {
        shipsRepository.fetchShips()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] ships in
                guard let self else { return }
                let sortedShips = ships.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
                shipsSubject.onNext(sortedShips)
            }, onError: { [weak self] error in
                guard let self else { return }
                errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteShip(at indexPath: IndexPath) {
        do {
            var ships = try shipsSubject.value()
            guard indexPath.row < ships.count else { return }
            
            let shipToDelete = ships[indexPath.row]
            shipsRepository.deleteShip(shipToDelete)
            
            ships.remove(at: indexPath.row)
            shipsSubject.onNext(ships)
        } catch {
            errorSubject.onNext(error)
        }
    }
}
