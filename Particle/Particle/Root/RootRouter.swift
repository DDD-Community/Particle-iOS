//
//  RootRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol RootInteractable: Interactable, LoggedOutListener, LoggedInListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: RootInteractor,
        viewController: RootViewControllable,
        loggedOutBuilder: LoggedOutBuildable,
        loggedInBuilder: LoggedInBuildable
    ) {
        self.loggedOutBuilder = loggedOutBuilder
        self.loggedInBuilder = loggedInBuilder
        super.init(
            interactor: interactor,
            viewController: viewController
        )
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        routeToLoggedOut()
    }
    
    func routeToLoggedIn() {
        if let loggedOut = self.loggedOut {
            detachChild(loggedOut)
            viewController.dismiss(viewController: loggedOut.viewControllable)
            self.loggedOut = nil
        }
        let loggedIn = loggedInBuilder.build(
            withListener: interactor
        )
        attachChild(loggedIn)
    }
    // MARK: - Private
    
    private let loggedOutBuilder: LoggedOutBuildable
    private let loggedInBuilder: LoggedInBuildable
    
    private var loggedOut: ViewableRouting?
//    private var loggedIn: Routing?
    
    private func routeToLoggedOut() {
        let loggedOut = loggedOutBuilder.build(withListener: interactor)
        self.loggedOut = loggedOut
        attachChild(loggedOut)
        viewController.present(viewController: loggedOut.viewControllable)
    }
}
