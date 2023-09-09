//
//  RecordDetailRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/02.
//

import RIBs

protocol RecordDetailInteractable: Interactable {
    var router: RecordDetailRouting? { get set }
    var listener: RecordDetailListener? { get set }
}

protocol RecordDetailViewControllable: ViewControllable {}

final class RecordDetailRouter: ViewableRouter<RecordDetailInteractable, RecordDetailViewControllable>, RecordDetailRouting {

    override init(interactor: RecordDetailInteractable, viewController: RecordDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
