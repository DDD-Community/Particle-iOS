//
//  SetInterestedTagsInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/10.
//

import RIBs
import RxSwift

protocol SetInterestedTagsRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SetInterestedTagsPresentable: Presentable {
    var listener: SetInterestedTagsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    func showUploadSuccessAlert()
}

protocol SetInterestedTagsListener: AnyObject {
    func setInterestedTagsBackButtonTapped()
//    func setInterestedTagsOKButtonTapped()
}

final class SetInterestedTagsInteractor: PresentableInteractor<SetInterestedTagsPresentable>,
                                         SetInterestedTagsInteractable,
                                         SetInterestedTagsPresentableListener {

    weak var router: SetInterestedTagsRouting?
    weak var listener: SetInterestedTagsListener?
    private let setInterestedTagsUseCase: SetInterestedTagsUseCase
    private var disposeBag = DisposeBag()

    init(
        presenter: SetInterestedTagsPresentable,
        setInterestedTagsUseCase: SetInterestedTagsUseCase
    ) {
        self.setInterestedTagsUseCase = setInterestedTagsUseCase
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
    }

    override func willResignActive() {
        super.willResignActive()
        
    }
    
    // MARK: - SelectInterestedTagsPresentableListener
    
    func setInterestedTagsBackButtonTapped() {
        listener?.setInterestedTagsBackButtonTapped()
    }
    
    func setInterestedTagsOKButtonTapped(with tags: [String]) {

        setInterestedTagsUseCase.execute(tags: tags)
            .subscribe { [weak self] dto in
                self?.presenter.showUploadSuccessAlert()
            } onError: { error in
                Console.error(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
