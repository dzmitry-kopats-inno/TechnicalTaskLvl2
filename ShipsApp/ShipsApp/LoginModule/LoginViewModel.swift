//
//  LoginViewModel.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 18/12/2024.
//

import Foundation
import RxSwift

final class LoginViewModel {
    private let networkMonitorService: NetworkMonitorService
    private let validationService: ValidationService
    private let loginService: LoginService
    private let disposeBag = DisposeBag()
    private let errorSubject = PublishSubject<Error>()
    private let successSubject = PublishSubject<Void>()
    
    var error: Observable<Error> {
        errorSubject.asObservable()
    }
    
    var success: Observable<Void> {
        successSubject.asObservable()
    }
    
    var isNetworkAvailable: Observable<Bool> {
        networkMonitorService.isNetworkAvailable
    }
    
    init(
        networkMonitorService: NetworkMonitorService,
        validationService: ValidationService,
        loginService: LoginService
    ) {
        self.networkMonitorService = networkMonitorService
        self.validationService = validationService
        self.loginService = loginService
        
        networkMonitorService.start()
    }
    
    func login(email: String?, password: String?) {
        guard let email, !email.isEmpty, let password, !password.isEmpty else {
            errorSubject.onNext(AppError(message: "Email and password cannot be empty."))
            return
        }
        
        guard validationService.isValid(email) else {
            errorSubject.onNext(AppError(message: "Invalid email format: \(email)"))
            return
        }
        
        loginService.login(email: email, password: password)
            .subscribe { [weak self] in
                guard let self else { return }
                successSubject.onNext(())
            } onFailure: { [weak self] error in
                guard let self else { return }
                errorSubject.onNext(error)
            }
            .disposed(by: disposeBag)
    }
    
    func getNetworkMonitorService() -> NetworkMonitorService {
        networkMonitorService
    }
}
