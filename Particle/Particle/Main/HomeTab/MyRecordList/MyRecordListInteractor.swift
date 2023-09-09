//
//  MyRecordListInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/03.
//

import RIBs
import RxSwift

protocol MyRecordListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MyRecordListPresentable: Presentable {
    var listener: MyRecordListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MyRecordListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MyRecordListInteractor: PresentableInteractor<MyRecordListPresentable>, MyRecordListInteractable, MyRecordListPresentableListener {

    weak var router: MyRecordListRouting?
    weak var listener: MyRecordListListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MyRecordListPresentable) {
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
}
