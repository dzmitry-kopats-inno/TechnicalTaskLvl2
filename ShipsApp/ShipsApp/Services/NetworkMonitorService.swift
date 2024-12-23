//
//  NetworkMonitorService.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 18/12/2024.
//

import Network
import RxSwift

protocol NetworkMonitorService {
    var isNetworkAvailable: Observable<Bool> { get }
    
    func start()
}

final class NetworkMonitorServiceImplementation: NetworkMonitorService {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    private let networkStatusSubject: BehaviorSubject<Bool>
    
    var isNetworkAvailable: Observable<Bool> {
        networkStatusSubject.asObservable()
    }
    
    init(monitor: NWPathMonitor = NWPathMonitor()) {
        self.monitor = monitor
        let initialStatus = monitor.currentPath.status == .satisfied
        self.networkStatusSubject = BehaviorSubject(value: initialStatus)
    }
    
    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            let isAvailable = path.status == .satisfied
            networkStatusSubject.onNext(isAvailable)
        }
        
        monitor.start(queue: queue)
    }
}
