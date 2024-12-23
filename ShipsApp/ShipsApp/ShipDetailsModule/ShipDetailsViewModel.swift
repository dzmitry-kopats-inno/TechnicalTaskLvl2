//
//  ShipDetailsViewModel.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 23/12/2024.
//

import Foundation
import RxSwift
import RxCocoa

final class ShipDetailsViewModel {
    private let ship: ShipModel
    private let networkMonitorService: NetworkMonitorService
    private let disposeBag = DisposeBag()
    
    private let networkStatusSubject = BehaviorSubject<Bool>(value: true)
    
    var networkStatus: Observable<Bool> {
        networkStatusSubject.asObservable()
    }
    
    var shipModel: ShipModel {
        ship
    }
    
    init(ship: ShipModel, networkMonitorService: NetworkMonitorService) {
        self.ship = ship
        self.networkMonitorService = networkMonitorService
        
        bindNetworkStatus()
    }
}

private extension ShipDetailsViewModel {
    func bindNetworkStatus() {
        networkMonitorService.isNetworkAvailable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isAvailable in
                guard let self else { return }
                self.networkStatusSubject.onNext(isAvailable)
            })
            .disposed(by: disposeBag)
    }
}
