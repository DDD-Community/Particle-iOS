//
//  EditSentenceInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift

protocol EditSentenceRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EditSentencePresentable: Presentable {
    var listener: EditSentencePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol EditSentenceListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func pushToNextVC()
}

final class EditSentenceInteractor: PresentableInteractor<EditSentencePresentable>, EditSentenceInteractable, EditSentencePresentableListener {

    weak var router: EditSentenceRouting?
    weak var listener: EditSentenceListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: EditSentencePresentable) {
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
    
    func pushToNextVC() {
        listener?.pushToNextVC()
    }
}
