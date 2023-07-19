//
//  SelectSentenceRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol SelectSentenceInteractable: Interactable, EditSentenceListener, OrganizingSentenceListener {
    var router: SelectSentenceRouting? { get set }
    var listener: SelectSentenceListener? { get set }
}

protocol SelectSentenceViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
    func pushViewController(_ viewController: ViewControllable)
}

final class SelectSentenceRouter: ViewableRouter<SelectSentenceInteractable,
                                  SelectSentenceViewControllable>,
                                  SelectSentenceRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: SelectSentenceInteractable,
        viewController: SelectSentenceViewControllable,
        editSentenceBuilder: EditSentenceBuildable,
        organizingSentenceBuilder: OrganizingSentenceBuildable
    ) {
        self.editSentenceBuilder = editSentenceBuilder
        self.organizingSentenceBuilder = organizingSentenceBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToEditSentence() {
        let editSentence = editSentenceBuilder.build(withListener: interactor)
        self.currentChild = editSentence
        attachChild(editSentence)
        viewController.present(viewController: editSentence.viewControllable)
    }
    

    func routeToOrganizingSentence() {
        detachEditSentence()
        attachOrganizingSentence()
    }
    
    // MARK: - Private
    
    private let editSentenceBuilder: EditSentenceBuildable
    private let organizingSentenceBuilder: OrganizingSentenceBuildable
    private var currentChild: ViewableRouting?
    
    private func detachEditSentence() { // ?
        
        if let editSentence = currentChild {
            detachChild(editSentence)
            viewController.dismiss(viewController: editSentence.viewControllable)
            currentChild = nil
        }
    }
    
    private func attachOrganizingSentence() {
        let organizingSentence = organizingSentenceBuilder.build(withListener: interactor)
        self.currentChild = organizingSentence
        attachChild(organizingSentence)
        viewController.pushViewController(organizingSentence.viewControllable)
    }
    
}
