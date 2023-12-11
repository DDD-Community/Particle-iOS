//
//  SearchRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol SearchInteractable: Interactable, MyRecordListListener{
    var router: SearchRouting? { get set }
    var listener: SearchListener? { get set }
}

protocol SearchViewControllable: ViewControllable {
    func showSearchResult()
    func hiddenSearchResult()
}

final class SearchRouter: ViewableRouter<SearchInteractable, SearchViewControllable>, SearchRouting {
    
    init(
        interactor: SearchInteractable,
        viewController: SearchViewControllable,
        myRecordListBuildable: MyRecordListBuilder
    ) {
        self.myRecordListBuildable = myRecordListBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachMyRecordList(tag: String) {
        if myRecordListRouting != nil {
            return
        }
        let router = myRecordListBuildable.build(withListener: interactor, tag: tag)
        viewController.pushViewController(router.viewControllable, animated: true)
        attachChild(router)
        myRecordListRouting = router
    }
    
    func detachMyRecordList() {
        if let myRecordList = myRecordListRouting {
            viewController.popViewController(animated: true)
            detachChild(myRecordList)
            myRecordListRouting = nil
        }
    }
    
    // MARK: - Private
    private let myRecordListBuildable: MyRecordListBuildable
    private var myRecordListRouting: MyRecordListRouting?
}
