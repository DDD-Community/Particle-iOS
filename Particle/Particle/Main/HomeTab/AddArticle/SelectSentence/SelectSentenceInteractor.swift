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
    func attachEditSentence(with text: String)
    func detachEditSentence()
}

protocol SelectSentencePresentable: Presentable {
    var listener: SelectSentencePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SelectSentenceListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func popSelectSentence()
    func pushToOrganizingSentence()
}

final class SelectSentenceInteractor: PresentableInteractor<SelectSentencePresentable>,
                                      SelectSentenceInteractable,
                                      SelectSentencePresentableListener {
    
    weak var router: SelectSentenceRouting?
    weak var listener: SelectSentenceListener?
    
    private var organizingSentenceRepository: OrganizingSentenceRepository
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: SelectSentencePresentable, repository: OrganizingSentenceRepository) {
        self.organizingSentenceRepository = repository
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
    
    
    // MARK: - SelectSentencePresentableListener
    
    func showEditSentenceModal(with text: String) {
        router?.attachEditSentence(with: text)
    }
    
    func dismissEditSentence(with text: String) {
        guard var list = try? organizingSentenceRepository.sentenceFile.value() else {
            Console.error("\(#function) value 를 가져올 수 없습니다.")
            return
        }
        list.append(text)
        organizingSentenceRepository.sentenceFile.onNext(list)
        router?.detachEditSentence()
    }
    
    func backButtonTapped() {
        listener?.popSelectSentence()
    }
    
    func nextButtonTapped() {
        listener?.pushToOrganizingSentence()
    }
}
