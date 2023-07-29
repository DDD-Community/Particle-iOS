//
//  MainRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol MainInteractable: Interactable,
                           HomeListener,
                           ExploreListener,
                           SearchListener,
                           MyPageListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {
    
    
    private var navigationControllable: NavigationControllerable?
    
    private let home: HomeBuildable
    private let explore: ExploreBuildable
    private let search: SearchBuildable
    private let mypage: MyPageBuildable
    
    private var homeRouting: ViewableRouting?
    private var exploreRouting: ViewableRouting?
    private var searchRouting: ViewableRouting?
    private var mypageRouting: ViewableRouting?
    
    init(
        interactor: MainInteractable,
        viewController: MainViewControllable,
        home: HomeBuildable,
        explore: ExploreBuildable,
        search: SearchBuildable,
        mypage: MyPageBuildable
        
    ) {
        self.home = home
        self.explore = explore
        self.search = search
        self.mypage = mypage
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    //    func routeToAddArticle() {
    //        let organizingSentenceRouter = organizingSentenceBuilder.build(withListener: interactor)
    //        self.organizingSentence = organizingSentenceRouter
    //        attachChild(organizingSentenceRouter)
    //
    //        presentInsideNavigation(organizingSentenceRouter.viewControllable)
    //    }
    //
    //    func popToAddArticle() {
    //        guard let router = organizingSentence else {
    //            return
    //        }
    //
    //        guard let navigationControllable = navigationControllable else {
    //            return
    //        }
    //
    //        navigationControllable.dismiss(completion: nil)
    //
    //        detachChild(router)
    //        organizingSentence = nil
    //        self.navigationControllable = nil
    //    }
    //
    //    func routeToSetAdditionalInfo() {
    //        let router = setAdditionalInfoBuilder.build(withListener: interactor)
    //        self.setAdditionalInfo = router
    //        attachChild(router)
    //
    //        guard let navigationControllable = navigationControllable else {
    //            presentInsideNavigation(router.viewControllable)
    //            return
    //        }
    //
    //        navigationControllable.pushViewController(router.viewControllable, animated: true)
    //    }
    //
    //    func popSetAdditionalInfo() {
    //        guard let router = setAdditionalInfo else {
    //            return
    //        }
    //
    //        guard let navigationControllable = navigationControllable else {
    //            return
    //        }
    //
    //        navigationControllable.popViewController(animated: true)
    //
    //        detachChild(router)
    //        setAdditionalInfo = nil
    //    }
    //
    //    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
    //        let navigation = NavigationControllerable(root: viewControllable)
    //        self.navigationControllable = navigation
    //        navigation.navigationController.navigationBar.isHidden = true
    //        navigation.navigationController.modalPresentationStyle  = .fullScreen
    //        viewController.present(navigation, animated: true, completion: nil)
    //    }
    
    func attachTabs() {
        let home = home.build(withListener: interactor)
        let explore = explore.build(withListener: interactor)
        let search = search.build(withListener: interactor)
        let mypage = mypage.build(withListener: interactor)
        
        attachChild(home)
        attachChild(explore)
        attachChild(search)
        attachChild(mypage)
        
        let viewControllers = [
            NavigationControllerable(root: home.viewControllable),
            NavigationControllerable(root: explore.viewControllable),
            NavigationControllerable(root: search.viewControllable),
            NavigationControllerable(root: mypage.viewControllable)
        ]
        
        viewController.setViewControllers(viewControllers)
    }
    
}
