//
//  MainBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol MainDependency: Dependency {
    var organizingSentenceRepository: OrganizingSentenceRepository { get }
}

final class MainComponent: Component<MainDependency>, OrganizingSentenceDependency {
    var organizingSentenceRepository: OrganizingSentenceRepository {
        dependency.organizingSentenceRepository
    }
}

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
        let organizingSentenceBuilder = OrganizingSentenceBuilder(dependency: component)
        return MainRouter(interactor: interactor, viewController: viewController, organizingSentenceBuilder: organizingSentenceBuilder)
    }
}
