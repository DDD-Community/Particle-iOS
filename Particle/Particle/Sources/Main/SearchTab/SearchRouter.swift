//
//  SearchRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol SearchInteractable: Interactable {
    var router: SearchRouting? { get set }
    var listener: SearchListener? { get set }
}

protocol SearchViewControllable: ViewControllable {
    func addSearchResult(_ view: UIViewController)
    func removeSearchResult()
}

final class SearchRouter: ViewableRouter<SearchInteractable, SearchViewControllable>, SearchRouting {
    
    private let searchResultBuilder: SearchResultBuildable
    private var searchResultRouter: SearchResultRouting?
    
    init(
        interactor: SearchInteractable,
        viewController: SearchViewControllable,
        searchResultBuildable: SearchResultBuildable
    ) {
        self.searchResultBuilder = searchResultBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSearchResult() {
        guard searchResultRouter == nil else { return }
        let router = searchResultBuilder.build(withListener: interactor)
        viewController.addSearchResult(router.viewControllable.uiviewController)
        attachChild(router)
        searchResultRouter = router
    }
    
    func detachSearchResult() {
        guard let searchResult = searchResultRouter else { return }
        viewController.removeSearchResult()
        detachChild(searchResult)
        searchResultRouter = nil 
    }
}
