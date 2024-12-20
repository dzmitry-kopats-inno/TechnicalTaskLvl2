//
//  LoginService.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 20/12/2024.
//

import Foundation
import RxSwift

protocol LoginService {
    func login(email: String, password: String) -> Single<Void>
}

final class LoginServiceImplementation: LoginService {
    private let userRepository: UserRepository
    private let delay: TimeInterval
    
    init(userRepository: UserRepository, delay: TimeInterval = 2.0) {
        self.userRepository = userRepository
        self.delay = delay
    }
    
    func login(email: String, password: String) -> Single<Void> {
        return Single<Void>.create { [weak self] single in
            guard let self else {
                single(.failure(AppError(message: "LoginService unavailable")))
                return Disposables.create()
            }
            
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                if let storedPassword = self.userRepository.fetchUserPassword(email: email),
                   storedPassword == password {
                    single(.success(()))
                } else {
                    single(.failure(AppError(message: "Invalid credentials")))
                }
            }
            
            return Disposables.create()
        }
    }
}
