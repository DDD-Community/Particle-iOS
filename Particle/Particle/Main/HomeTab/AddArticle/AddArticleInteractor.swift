//
//  AddArticleInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift
import Photos

protocol AddArticleRouting: Routing {
    func cleanupViews()
    
    func attachPhotoPicker()
    func detachPhotoPicker()
    
    func attachSelectSentence(with images: [PHAsset])
    func detachSelectSentence()
    
    func attachOrganizingSentence()
    func detachOrganizingSentence()
    
    func attachSetAdditionalInformation()
    func detachSetAdditionalInformation()
}

protocol AddArticleListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class AddArticleInteractor: Interactor, AddArticleInteractable {

    weak var router: AddArticleRouting?
    weak var listener: AddArticleListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init() {
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
    
    func nextButtonTapped(with images: [PHAsset]) {
        router?.attachSelectSentence(with: images)
    }
    
    // MARK: - SelectSentenceListener
    
    func popSelectSentence() {
        router?.detachSelectSentence()
    }
    
    func pushToOrganizingSentence() {
        router?.attachOrganizingSentence()
    }
    
    
    // MARK: - OrganizingSentenceListener
    
    func organizingSentenceNextButtonTapped() {
        router?.attachSetAdditionalInformation()
    }
    
    func organizingSentenceBackButtonTapped() {
        router?.detachOrganizingSentence()
    }
    
    // MARK: - SetAdditionalInformationListener
    
    func setAdditionalInfoBackButtonTapped() {
        router?.detachSetAdditionalInformation()
    }
}
