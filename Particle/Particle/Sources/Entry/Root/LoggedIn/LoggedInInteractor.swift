//
//  LoggedInInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift

protocol LoggedInRouting: Routing {
    func cleanupViews()
}

protocol LoggedInListener: AnyObject {}

final class LoggedInInteractor: Interactor, LoggedInInteractable {

    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?

    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
    }
}
