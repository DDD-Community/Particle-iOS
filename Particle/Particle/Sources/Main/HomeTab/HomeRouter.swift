//
//  HomeRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol HomeInteractable: Interactable, AddArticleListener, RecordDetailListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
    
    init(
        interactor: HomeInteractable,
        viewController: HomeViewControllable,
        addArticleBuildable: AddArticleBuildable,
        recordDetailBuildable: RecordDetailBuildable
    ) {
        self.addArticleBuildable = addArticleBuildable
        self.recordDetailBuildable = recordDetailBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - AddArticle RIB
    
    func attachAddArticle() {
        let addArticle = addArticleBuildable.build(withListener: interactor)
        self.addArticleRouting = addArticle
        attachChild(addArticle)
    }
    
    func detachAddArticle() {
        if let addArticle = addArticleRouting {
            detachChild(addArticle)
            addArticleRouting = nil
        }
    }
    
    // MARK: - RecordDetail RIB
    
    func attachRecordDetail(data: RecordReadDTO) {
        if recordDetailRouting != nil {
            return
        }
        let router = recordDetailBuildable.build(withListener: interactor, data: data)
        viewController.pushViewController(router.viewControllable, animated: true)
        attachChild(router)
        recordDetailRouting = router
    }
    
    func detachRecordDetail() {
        if let recordDetail = recordDetailRouting {
            viewController.popViewController(animated: true)
            detachChild(recordDetail)
            recordDetailRouting = nil
        }
    }
    
    // MARK: - Private
    
    private let addArticleBuildable: AddArticleBuildable
    private var addArticleRouting: AddArticleRouting?
    
    private let recordDetailBuildable: RecordDetailBuildable
    private var recordDetailRouting: RecordDetailRouting?
}
