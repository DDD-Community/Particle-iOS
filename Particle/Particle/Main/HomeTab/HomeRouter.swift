//
//  HomeRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol HomeInteractable: Interactable, AddArticleListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
 

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: HomeInteractable,
        viewController: HomeViewControllable,
        addArticleBuilder: AddArticleBuildable
    ) {
        self.addArticleBuilder = addArticleBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - HomeRouting
    func routeToAddArticle() {
        let addArticle = addArticleBuilder.build(withListener: interactor)
        self.currentChild = addArticle
        attachChild(addArticle)
    }
    
    func detachAddArticle() {
        if let addArticle = currentChild {
            detachChild(addArticle)
            currentChild = nil
        }
    }
    
    // MARK: - Private
    
    private let addArticleBuilder: AddArticleBuildable
    private var currentChild: Routing?
    
}
