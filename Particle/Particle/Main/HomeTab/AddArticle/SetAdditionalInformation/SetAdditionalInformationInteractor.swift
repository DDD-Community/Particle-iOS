//
//  SetAdditionalInformationInteractor.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import RIBs
import RxSwift

protocol SetAdditionalInformationRouting: ViewableRouting {
    
}

protocol SetAdditionalInformationPresentable: Presentable {
    var listener: SetAdditionalInformationPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SetAdditionalInformationListener: AnyObject {
    func setAdditionalInfoBackButtonTapped()
}

final class SetAdditionalInformationInteractor: PresentableInteractor<SetAdditionalInformationPresentable>, SetAdditionalInformationInteractable, SetAdditionalInformationPresentableListener {

    weak var router: SetAdditionalInformationRouting?
    weak var listener: SetAdditionalInformationListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SetAdditionalInformationPresentable) {
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
    
    func setAdditionalInfoBackButtonTapped() {
        listener?.setAdditionalInfoBackButtonTapped()
    }
}
