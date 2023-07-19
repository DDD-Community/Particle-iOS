//
//  SelectSentenceInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/13.
//

import RIBs
import RxSwift

protocol SelectSentenceRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToEditSentence()
    func routeToOrganizingSentence()
}

protocol SelectSentencePresentable: Presentable {
    var listener: SelectSentencePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SelectSentenceListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func popSelectSentence()
}

final class SelectSentenceInteractor: PresentableInteractor<SelectSentencePresentable>,
                                      SelectSentenceInteractable,
                                      SelectSentencePresentableListener {

    weak var router: SelectSentenceRouting?
    weak var listener: SelectSentenceListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SelectSentencePresentable) {
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
    
    func showEditSentenceModal() {
        router?.routeToEditSentence()
    }
    
    func pushToNextVC() {
        router?.routeToOrganizingSentence()
    }
    
    func organizingSentenceNextButtonTapped() {
        //
    }
    
    func organizingSentenceBackButtonTapped() {
        //
    }
    
    func backButtonTapped() {
        // addarticle로 돌아가기
        listener?.popSelectSentence()
    }
}
