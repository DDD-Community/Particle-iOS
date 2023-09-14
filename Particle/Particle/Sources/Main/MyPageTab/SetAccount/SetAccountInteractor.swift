//
//  SetAccountInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs
import RxSwift

protocol SetAccountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SetAccountPresentable: Presentable {
    var listener: SetAccountPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SetAccountListener: AnyObject {
    func setAccountBackButtonTapped()
}

final class SetAccountInteractor: PresentableInteractor<SetAccountPresentable>, SetAccountInteractable, SetAccountPresentableListener {
    
    weak var router: SetAccountRouting?
    weak var listener: SetAccountListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SetAccountPresentable) {
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
    
    // MARK: - SetAccountPresentableListener
    
    func backButtonTapped() {
        listener?.setAccountBackButtonTapped()
    }
}
