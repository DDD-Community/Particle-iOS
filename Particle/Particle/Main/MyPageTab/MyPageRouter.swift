//
//  MyPageRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol MyPageInteractable: Interactable, SetAccountListener, SetAlarmListener {
    var router: MyPageRouting? { get set }
    var listener: MyPageListener? { get set }
}

protocol MyPageViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MyPageRouter: ViewableRouter<MyPageInteractable, MyPageViewControllable>,
                          MyPageRouting {
    
    init(
        interactor: MyPageInteractable,
        viewController: MyPageViewControllable,
        setAccountBuildable: SetAccountBuildable,
        setAlarmBuildable: SetAlarmBuildable
    ) {
        self.setAccountBuildable = setAccountBuildable
        self.setAlarmBuildable = setAlarmBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - MyPageRouting
    
    // MARK: - SetAccount RIB
    
    func attachSetAccount() {
        if setAccountRouting != nil {
            return
        }
        let router = setAccountBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        attachChild(router)
        setAccountRouting = router
    }
    
    func detachSetAccount() {
        if let setAccount = setAccountRouting {
            viewController.popViewController(animated: true)
            detachChild(setAccount)
            setAccountRouting = nil
        }
    }
    
    // MARK: - SetAlarm RIB
    
    func attachSetAlarm() {
        if setAlarmRouting != nil {
            return
        }
        let router = setAlarmBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        attachChild(router)
        setAlarmRouting = router
    }
    
    func detachSetAlarm() {
        if let setAlarm = setAlarmRouting {
            viewController.popViewController(animated: true)
            detachChild(setAlarm)
            setAlarmRouting = nil
        }
    }
    
    
    // MARK: - Private
    
    private let setAccountBuildable: SetAccountBuildable
    private var setAccountRouting: SetAccountRouting?
    
    private let setAlarmBuildable: SetAlarmBuildable
    private var setAlarmRouting: SetAlarmRouting?
}
