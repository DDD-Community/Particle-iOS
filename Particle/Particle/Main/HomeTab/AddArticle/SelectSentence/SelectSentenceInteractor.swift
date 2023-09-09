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
    func showSwipeAnimation()
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
    
    func backButtonTapped() {
        listener?.popSelectSentence()
    }
    
    func nextButtonTapped() {
        listener?.pushToOrganizingSentence()
    }
    
    // MARK: - SelectSentenceInteractable
    
    func dismissEditSentence(with text: String) {
//        guard var list = try? organizingSentenceRepository.sentenceFile.value() else {
//            Console.error("\(#function) value 를 가져올 수 없습니다.")
//            return
//        }
//        list.append(text)
//        organizingSentenceRepository.sentenceFile.onNext(list)
        
        // TEST
        
        var list2 = organizingSentenceRepository.sentenceFile2.value
        list2.append(.init(sentence: text, isRepresent: false))
        organizingSentenceRepository.sentenceFile2.accept(list2)
        
        // TEST
        
        router?.detachEditSentence()
    }
    
    func swipeToNextPhoto() {
        // TODO: 다음 사진으로 자동 스와이프 처리
        presenter.showSwipeAnimation()
    }
    
}
