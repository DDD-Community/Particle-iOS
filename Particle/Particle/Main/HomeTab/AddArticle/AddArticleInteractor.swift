//
//  AddArticleInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift

protocol AddArticleRouting: Routing {
    func cleanupViews()
    
    func attachPhotoPicker()
    func detachPhotoPicker()
    
    func attachSelectSentence(with images: [NSItemProvider])
}

protocol AddArticleListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class AddArticleInteractor: Interactor, AddArticleInteractable {
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    

    weak var router: AddArticleRouting?
    weak var listener: AddArticleListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init() {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachPhotoPicker()
    }

    override func willResignActive() {
        super.willResignActive()
        
        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    // MARK: - PhotoPickerListener
    
    func cancelButtonTapped() {
        router?.detachPhotoPicker()
    }
    
    func nextButtonTapped(with images: [NSItemProvider]) {
        router?.attachSelectSentence(with: images)
    }
    
    // MARK: - SelectSentenceListener
    
    func popSelectSentence() {
        // TODO:
    }
    

}
