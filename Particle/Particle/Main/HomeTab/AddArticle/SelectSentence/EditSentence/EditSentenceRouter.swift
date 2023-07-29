//
//  EditSentenceRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol EditSentenceInteractable: Interactable {
    var router: EditSentenceRouting? { get set }
    var listener: EditSentenceListener? { get set }
}

protocol EditSentenceViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class EditSentenceRouter: ViewableRouter<EditSentenceInteractable, EditSentenceViewControllable>, EditSentenceRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: EditSentenceInteractable, viewController: EditSentenceViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
