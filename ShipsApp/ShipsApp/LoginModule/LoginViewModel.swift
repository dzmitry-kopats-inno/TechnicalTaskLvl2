//
//  LoginViewModel.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 18/12/2024.
//

import Foundation
import RxSwift

final class LoginViewModel {
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
    
    init(validationService: ValidationService, loginService: LoginService) {
        self.validationService = validationService
        self.loginService = loginService
    }
    
    func login(email: String?, password: String?) {
        guard let email, !email.isEmpty, let password, !password.isEmpty else {
            errorSubject.onNext(AppError(message: "Email and password cannot be empty."))
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
}
