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
    private var disposeBag = DisposeBag()

    override init(presenter: SetInterestedTagsPresentable) {
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

        let repo = UserRepository()
        repo.setTags(items: tags).subscribe { [weak self] result in
            switch result.element {
            case .success(let dto):
                UserDefaults.standard.set(dto.interestedTags.map { "#\($0)" }, forKey: "INTERESTED_TAGS")
                self?.presenter.showUploadSuccessAlert()
            case .failure(let error):
                // TODO: 실패얼럿 띄우기
                Console.error(error.localizedDescription)
            case .none:
                return
            }
        }
        .disposed(by: disposeBag)
    }
}
