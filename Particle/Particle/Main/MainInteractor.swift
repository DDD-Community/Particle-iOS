//
//  MainInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift

protocol MainRouting: ViewableRouting {
    func attachTabs()
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
}

protocol MainListener: AnyObject {}

final class MainInteractor: PresentableInteractor<MainPresentable>,
                            MainInteractable,
                            MainPresentableListener {
    
    weak var router: MainRouting?
    weak var listener: MainListener?
    
    override init(presenter: MainPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachTabs()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
}
