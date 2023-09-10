//
//  MyPageInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift

protocol MyPageRouting: ViewableRouting {
    func attachSetAccount()
    func detachSetAccount()
    
    func attachSetAlarm()
    func detachSetAlarm()
    
    func attachSetInterestedTags()
    func detachSetInterestedTags()
}

protocol MyPagePresentable: Presentable {
    var listener: MyPagePresentableListener? { get set }
    
    func setData(data: UserReadDTO)
}

protocol MyPageListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MyPageInteractor: PresentableInteractor<MyPagePresentable>,
                              MyPageInteractable,
                              MyPagePresentableListener {
    
    weak var router: MyPageRouting?
    weak var listener: MyPageListener?
    
    private var disposeBag = DisposeBag()
    
    override init(presenter: MyPagePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: user정보 받아와서 저장
        let repo = UserRepository()
        repo.fetchMyProfile().subscribe { [weak self] result in
            switch result.element {
            case .success(let response):
                self?.presenter.setData(data: response)
                UserDefaults.standard.set(response.interestedTags.map { "#\($0)" }, forKey: "INTERESTED_TAGS")
            case .failure(let error):
                Console.error(error.localizedDescription)
            case .none:
                return
            }
        }
        .disposed(by: disposeBag)
        
    }
    
    override func willResignActive() {
        super.willResignActive()
        
    }
    
    // MARK: - MyPagePresentableListener
    
    func setAccountButtonTapped() {
        router?.attachSetAccount()
    }
    
    func setAlarmButtonTapped() {
        router?.attachSetAlarm()
    }
    
    func setInterestedTagsButtonTapped() {
        router?.attachSetInterestedTags()
    }
    
    
    // MARK: - MyPageInteractable
    
    func setAccountBackButtonTapped() {
        router?.detachSetAccount()
    }
    
    func setAlarmBackButtonTapped() {
        router?.detachSetAlarm()
    }
    
    func setInterestedTagsBackButtonTapped() {
        router?.detachSetInterestedTags()
    }
    
//    func setInterestedTagsOKButtonTapped() {
//        router?.detachSetInterestedTags()
//    }
}
