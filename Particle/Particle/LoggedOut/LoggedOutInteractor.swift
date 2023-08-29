//
//  LoggedOutInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift

protocol LoggedOutRouting: ViewableRouting {
    func routeToSelectTag()
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol LoggedOutListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func login()
}

final class LoggedOutInteractor: PresentableInteractor<LoggedOutPresentable>,
                                 LoggedOutInteractable,
                                 LoggedOutPresentableListener {
    
    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?
    
    override init(presenter: LoggedOutPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: - LoggedOutPresentableListener
    
    func successLogin() {
        // TODO: 첫번째 가입이면, SelectTag RIB 로 이동. 아니면 LoggedIn RIB로 이동.
//        guard let isFirstLogin = UserDefaults.standard.object(forKey: "isFirstLogin") as? Bool else {
//            UserDefaults.standard.set(false, forKey: "isFirstLogin")
//            router?.routeToSelectTag()
//            return
//        }
//        if isFirstLogin {
//
//        } else {
//            listener?.login()
//        }
        router?.routeToSelectTag()
    }
    
    // MARK: - SelectTagListener
    
    func selectTagStartButtonTapped() {
        listener?.login()
    }
}
