//
//  OrganizingSentenceInteractor.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/11.
//

import RIBs
import RxSwift

protocol OrganizingSentenceRouting: ViewableRouting {
    
}

protocol OrganizingSentencePresentable: Presentable {
    var listener: OrganizingSentencePresentableListener? { get set }
    
    func setUpData(with viewModels: [OrganizingSentenceViewModel])
}

//protocol OrganizingSentenceInteractorDependency {
//    var organizingSentenceRepository: OrganizingSentenceRepository { get }
//}

protocol OrganizingSentenceListener: AnyObject {
    func organizingSentenceNextButtonTapped()
    func organizingSentenceBackButtonTapped()
}

final class OrganizingSentenceInteractor: PresentableInteractor<OrganizingSentencePresentable>,
                                          OrganizingSentenceInteractable,
                                          OrganizingSentencePresentableListener {

    weak var router: OrganizingSentenceRouting?
    weak var listener: OrganizingSentenceListener?

    private let organizingSentenceRepository: OrganizingSentenceRepository
    private var disposeBag: DisposeBag = .init()
    
    init(
        presenter: OrganizingSentencePresentable,
        dependency: OrganizingSentenceRepository
    ) {
        self.organizingSentenceRepository = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
//        dependency.organizingSentenceRepository
//            .sentenceFile
//            .bind { [weak self] sentences in
//                let viewModels = sentences.map {
//                    OrganizingSentenceViewModel(
//                        sentence: $0, isRepresent: false
//                    )
//                }
//                self?.presenter.setUpData(with: viewModels)
//            }
//            .disposed(by: disposeBag)
        
        // TEST
        organizingSentenceRepository.sentenceFile2.bind { [weak self] in
            self?.presenter.setUpData(with: $0)
        }
        .disposed(by: disposeBag)
        
        // TEST
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - OrganizingSentencePresentableListener
    
    func nextButtonTapped(with data: [OrganizingSentenceViewModel]) {
        organizingSentenceRepository.sentenceFile2.accept(data)
        
        listener?.organizingSentenceNextButtonTapped()
    }
    
    func backButtonTapped() {
        listener?.organizingSentenceBackButtonTapped()
    }
}
