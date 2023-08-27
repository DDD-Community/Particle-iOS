//
//  SelectTagRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/24.
//

import RIBs

protocol SelectTagInteractable: Interactable {
    var router: SelectTagRouting? { get set }
    var listener: SelectTagListener? { get set }
}

protocol SelectTagViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SelectTagRouter: ViewableRouter<SelectTagInteractable, SelectTagViewControllable>, SelectTagRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SelectTagInteractable, viewController: SelectTagViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
