//
//  MainRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol MainInteractable: Interactable, OrganizingSentenceListener, SetAdditionalInformationListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {
    
    private var navigationControllable: NavigationControllerable?
    
    private let organizingSentenceBuilder: OrganizingSentenceBuildable
    private var organizingSentence: ViewableRouting?
    
    private let setAdditionalInfoBuilder: SetAdditionalInformationBuildable
    private var setAdditionalInfo: ViewableRouting?
    
    init(
        interactor: MainInteractable,
        viewController: MainViewControllable,
        // 이건 add article로 바꿔야함
        organizingSentenceBuilder: OrganizingSentenceBuildable,
        setAdditionalInfoBuilder: SetAdditionalInformationBuildable
    ) {
        self.organizingSentenceBuilder = organizingSentenceBuilder
        self.setAdditionalInfoBuilder = setAdditionalInfoBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToAddArticle() {
        let organizingSentenceRouter = organizingSentenceBuilder.build(withListener: interactor)
        self.organizingSentence = organizingSentenceRouter
        attachChild(organizingSentenceRouter)
        
        presentInsideNavigation(organizingSentenceRouter.viewControllable)
    }
    
    func popToAddArticle() {
        guard let router = organizingSentence else {
            return
        }
        
        guard let navigationControllable = navigationControllable else {
            return
        }
        
        navigationControllable.dismiss(completion: nil)
        
        detachChild(router)
        organizingSentence = nil
        self.navigationControllable = nil 
    }
    
    func routeToSetAdditionalInfo() {
        let router = setAdditionalInfoBuilder.build(withListener: interactor)
        self.setAdditionalInfo = router
        attachChild(router)
        
        guard let navigationControllable = navigationControllable else {
            presentInsideNavigation(router.viewControllable)
            return
        }
        
        navigationControllable.pushViewController(router.viewControllable, animated: true)
    }
    
    func popSetAdditionalInfo() {
        guard let router = setAdditionalInfo else {
            return
        }
        
        guard let navigationControllable = navigationControllable else {
            return
        }
        
        navigationControllable.popViewController(animated: true)
        
        detachChild(router)
        setAdditionalInfo = nil
    }
    
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllerable(root: viewControllable)
        self.navigationControllable = navigation
        navigation.navigationController.navigationBar.isHidden = true
        navigation.navigationController.modalPresentationStyle  = .fullScreen
        viewController.present(navigation, animated: true, completion: nil)
    }
}
