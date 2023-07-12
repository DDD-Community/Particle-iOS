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
    
    func setUpData(with viewModels: [OrganizingSentenceViewModel])
}

protocol OrganizingSentenceInteractorDependency {
    var organizingSentenceRepository: OrganizingSentenceRepository { get }
}

protocol OrganizingSentenceListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class OrganizingSentenceInteractor: PresentableInteractor<OrganizingSentencePresentable>, OrganizingSentenceInteractable, OrganizingSentencePresentableListener {

    weak var router: OrganizingSentenceRouting?
    weak var listener: OrganizingSentenceListener?

    private let dependency: OrganizingSentenceInteractorDependency
    private var disposeBag: DisposeBag = .init()
    
    init(
        presenter: OrganizingSentencePresentable,
        dependency: OrganizingSentenceInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.organizingSentenceRepository
            .sentenceFile
            .bind { [weak self] sentences in
                let viewModels = sentences.map {
                    OrganizingSentenceViewModel(
                        sentence: $0, isRepresent: false
                    )
                }
                self?.presenter.setUpData(with: viewModels)
            }
            .disposed(by: disposeBag)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
