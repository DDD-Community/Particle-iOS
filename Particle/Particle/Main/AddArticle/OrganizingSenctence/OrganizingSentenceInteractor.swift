//
//  OrganizingSentenceInteractor.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/11.
//

import RIBs
import RxSwift

protocol OrganizingSentenceRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol OrganizingSentencePresentable: Presentable {
    var listener: OrganizingSentencePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol OrganizingSentenceListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class OrganizingSentenceInteractor: PresentableInteractor<OrganizingSentencePresentable>, OrganizingSentenceInteractable, OrganizingSentencePresentableListener {

    weak var router: OrganizingSentenceRouting?
    weak var listener: OrganizingSentenceListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: OrganizingSentencePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
