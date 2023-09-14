//
//  SetAlarmInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs
import RxSwift

protocol SetAlarmRouting: ViewableRouting {
    func attachDirectlySetAlarm()
    func detachDirectlySetAlarm()
}

protocol SetAlarmPresentable: Presentable {
    var listener: SetAlarmPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SetAlarmListener: AnyObject {
    func setAlarmBackButtonTapped()
}

final class SetAlarmInteractor: PresentableInteractor<SetAlarmPresentable>, SetAlarmInteractable, SetAlarmPresentableListener {
    
    weak var router: SetAlarmRouting?
    weak var listener: SetAlarmListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SetAlarmPresentable) {
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
    
    // MARK: - SetAlarmPresentableListener
    
    func setAlarmBackButtonTapped() {
        listener?.setAlarmBackButtonTapped()
    }
    
    func setAlarmDirectlySettingButtonTapped() {
        router?.attachDirectlySetAlarm()
    }
    
    func directlySetAlarmCloseButtonTapped() {
        router?.detachDirectlySetAlarm()
    }
}
