//
//  MyRecordListRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/03.
//

import RIBs

protocol MyRecordListInteractable: Interactable {
    var router: MyRecordListRouting? { get set }
    var listener: MyRecordListListener? { get set }
}

protocol MyRecordListViewControllable: ViewControllable {}

final class MyRecordListRouter: ViewableRouter<MyRecordListInteractable, MyRecordListViewControllable>,
                                MyRecordListRouting {

    override init(
        interactor: MyRecordListInteractable,
        viewController: MyRecordListViewControllable
    ) {
        super.init(
            interactor: interactor,
            viewController: viewController
        )
        interactor.router = self
    }
}
