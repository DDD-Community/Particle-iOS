//
//  SelectTagInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/24.
//

import RIBs
import RxSwift

protocol SelectTagRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SelectTagPresentable: Presentable {
    var listener: SelectTagPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SelectTagListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SelectTagInteractor: PresentableInteractor<SelectTagPresentable>, SelectTagInteractable, SelectTagPresentableListener {
   
    weak var router: SelectTagRouting?
    weak var listener: SelectTagListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SelectTagPresentable) {
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
    
    // MARK: - SelectTagPresentableListener
    
    func backButtonTapped() {
        // TODO: LoggedOut RIB로 돌아가기
    }
    
    func startButtonTapped() {
        // TODO: Main RIB로 넘어가기
    }
}
