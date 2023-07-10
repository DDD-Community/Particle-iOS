//
//  AddArticleRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol AddArticleInteractable: Interactable {
    var router: AddArticleRouting? { get set }
    var listener: AddArticleListener? { get set }
}

protocol AddArticleViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AddArticleRouter: ViewableRouter<AddArticleInteractable, AddArticleViewControllable>, AddArticleRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AddArticleInteractable, viewController: AddArticleViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
