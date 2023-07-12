//
//  MainRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol MainInteractable: Interactable, OrganizingSentenceListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {

    private let organizingSentenceBuilder: OrganizingSentenceBuildable
    private var organizingSentence: ViewableRouting?
    
    init(
        interactor: MainInteractable,
        viewController: MainViewControllable,
    // 이건 add article로 바꿔야함
        organizingSentenceBuilder: OrganizingSentenceBuildable
    ) {
        self.organizingSentenceBuilder = organizingSentenceBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToAddArticle() {
        let organizingSentence = organizingSentenceBuilder.build(withListener: interactor)
        self.organizingSentence = organizingSentence
        attachChild(organizingSentence)
        viewController.present(viewController: organizingSentence.viewControllable)
    }
}
