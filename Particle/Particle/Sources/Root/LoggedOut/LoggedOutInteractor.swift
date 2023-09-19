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
    
    private let disposeBag = DisposeBag()
    
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
    
    func successLogin(with provider: String, identifier: String) {
        let service = AuthService()
        let request = LoginRequest(provider: provider, identifier: identifier)
        
        service.login(with: request).subscribe { [weak self] result in
            
            switch result {
            case .success(let response):
                if response.isNew {
                    UserDefaults.standard.set("\(response.tokens.accessToken)", forKey: "ACCESSTOKEN")
                    UserDefaults.standard.set("\(response.tokens.refreshToken)", forKey: "REFRESHTOKEN")
                    self?.router?.routeToSelectTag()
                } else {
                    UserDefaults.standard.set("\(response.tokens.accessToken)", forKey: "ACCESSTOKEN")
                    UserDefaults.standard.set("\(response.tokens.refreshToken)", forKey: "REFRESHTOKEN")
                    self?.listener?.login()
                }
            case .failure(let error):
                Console.error(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - SelectTagListener
    
    func selectTagStartButtonTapped(with selectedTags: [String]) {
        let repository = UserRepository()
        
        repository.setTags(items: selectedTags).subscribe { [weak self] result in
            if let result = result.element {
                switch result {
                case .success(let response):
                    Console.log("\(response)")
                    self?.listener?.login()
                case .failure(let error):
                    Console.log(error.localizedDescription)
                }
            }
        }
        .disposed(by: disposeBag)
    }
}
