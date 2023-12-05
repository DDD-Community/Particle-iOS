//
//  LogoutUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/12/04.
//

import Foundation
import RxSwift

protocol LogoutUseCase {
    func execute() -> Observable<Bool>
}

final class DefaultLogoutUseCase: LogoutUseCase {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func execute() -> Observable<Bool> {
        authService.logout()
            .map { response in
                return response.status == 200
            }
    }
}
