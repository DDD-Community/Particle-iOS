//
//  SelectTagInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/24.
//

import RIBs
import RxSwift

protocol SelectTagRouting: ViewableRouting {}

protocol SelectTagPresentable: Presentable {
    var listener: SelectTagPresentableListener? { get set }
}

protocol SelectTagListener: AnyObject {
    func selectTagStartButtonTapped(with selectedTags: [String])
}

final class SelectTagInteractor: PresentableInteractor<SelectTagPresentable>, SelectTagInteractable, SelectTagPresentableListener {
   
    weak var router: SelectTagRouting?
    weak var listener: SelectTagListener?

    override init(presenter: SelectTagPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: - SelectTagPresentableListener
    
    func backButtonTapped() {
        // TODO: LoggedOut RIB로 돌아가기?
    }
    
    func startButtonTapped(with selectedTags: [String]) {
        listener?.selectTagStartButtonTapped(with: selectedTags)
    }
}
