//
//  MainBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol MainDependency: Dependency { }

final class MainComponent: Component<MainDependency> { }

// MARK: - Builder

protocol MainBuildable: Buildable {
    func build(withListener listener: MainListener) -> MainRouting
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {

    override init(dependency: MainDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MainListener) -> MainRouting {
        let component = MainComponent(dependency: dependency)
        let viewController = MainTabBarController()
        let interactor = MainInteractor(presenter: viewController)
        interactor.listener = listener
        
        let home = HomeBuilder(dependency: component)
        let explore = ExploreBuilder(dependency: component)
        let search = SearchBuilder(dependency: component)
        let mypage = MyPageBuilder(dependency: component)
        
        return MainRouter(
            interactor: interactor,
            viewController: viewController,
            home: home,
            explore: explore,
            search: search,
            mypage: mypage)
    }
}

extension MainComponent: HomeDependency,
                         ExploreDependency,
                         SearchDependency,
                         MyPageDependency {}
