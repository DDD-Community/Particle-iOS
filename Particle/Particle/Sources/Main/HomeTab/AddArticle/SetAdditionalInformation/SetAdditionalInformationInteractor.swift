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
}

protocol SetAdditionalInformationListener: AnyObject {
    func setAdditionalInfoBackButtonTapped()
    func setAdditionalInfoSuccessPost(data: RecordReadDTO)
}

final class SetAdditionalInformationInteractor: PresentableInteractor<SetAdditionalInformationPresentable>,
                                                SetAdditionalInformationInteractable,
                                                SetAdditionalInformationPresentableListener {
    
    weak var router: SetAdditionalInformationRouting?
    weak var listener: SetAdditionalInformationListener?

    private var disposeBag = DisposeBag()
    private let repository: OrganizingSentenceRepository

    init(
        presenter: SetAdditionalInformationPresentable,
        repository: OrganizingSentenceRepository
    ) {
        self.repository = repository
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
    
    // MARK: - SetAdditionalInformationPresentableListener
    
    func setAdditionalInfoBackButtonTapped() {
        listener?.setAdditionalInfoBackButtonTapped()
    }
    
    func setAdditionalInfoNextButtonTapped(title: String, url: String, tags: [String]) {
        
        let requestModel: [RecordCreateDTO.RecordItemCreateDTO] = repository.sentenceFile2.value.map {
            .init(content: $0.sentence, isMain: $0.isRepresent)
        }
        
        let repo = RecordRepository()
        repo.create(
            record: .init(title: title, url: url, items: requestModel, tags: tags)
        ).subscribe { [weak self] result in
            switch result.element {
            case .success(let response):
                Console.log("\(#function) success")
                self?.listener?.setAdditionalInfoSuccessPost(data: response)
            case .failure(let error):
                Console.log(error.localizedDescription)
            case .none:
                Console.error("none Error")
                return
            }
        }
        .disposed(by: self.disposeBag)
    }
}
