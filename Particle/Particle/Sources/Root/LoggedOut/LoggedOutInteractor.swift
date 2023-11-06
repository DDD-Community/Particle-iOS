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
}

protocol LoggedOutListener: AnyObject {
    func login()
}

final class LoggedOutInteractor: PresentableInteractor<LoggedOutPresentable>,
                                 LoggedOutInteractable,
                                 LoggedOutPresentableListener {
    
    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?
    
    private let loginUseCase: LoginUseCase
    private let setInterestedTagsUseCase: SetInterestedTagsUseCase
    private let disposeBag = DisposeBag()
    
    init(
        presenter: LoggedOutPresentable,
        loginUseCase: LoginUseCase,
        setInterestedTagsUseCase: SetInterestedTagsUseCase
    ) {
        self.loginUseCase = loginUseCase
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
    
    // MARK: - LoggedOutPresentableListener
    
    func successLogin(with provider: String, identifier: String) {
        let request = LoginRequest(provider: provider, identifier: identifier)
        
        loginUseCase.execute(with: request)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] isFirstLogin in
                if isFirstLogin {
                    self?.router?.routeToSelectTag()
                } else {
                    self?.listener?.login()
                }
            } onError: { error in
                Console.error(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - SelectTagListener
    
    func selectTagStartButtonTapped(with selectedTags: [String]) {
        
        setInterestedTagsUseCase.execute(tags: selectedTags)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] complete in
                if complete {
                    self?.listener?.login()
                }
            } onError: { error in
                Console.error(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
