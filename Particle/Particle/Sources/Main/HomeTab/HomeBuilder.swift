//
//  HomeBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol HomeDependency: Dependency {}

final class HomeComponent: Component<HomeDependency> {
    let rootViewController: HomeViewController
    
    init(
        dependency: HomeDependency,
        rootViewController: HomeViewController
    ) {
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol HomeBuildable: Buildable {
    func build(withListener listener: HomeListener) -> HomeRouting
}

final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HomeListener) -> HomeRouting {
        let viewController = HomeViewController()
        let component = HomeComponent(
            dependency: dependency,
            rootViewController: viewController // ?? 어떻게 된건지 잘 모름
        )
        let interactor = HomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let addArticleBuilder = AddArticleBuilder(dependency: component)
        let recordDetailBuilder = RecordDetailBuilder(dependency: component)
        
        return HomeRouter(
            interactor: interactor,
            viewController: viewController,
            addArticleBuildable: addArticleBuilder,
            recordDetailBuildable: recordDetailBuilder
        )
    }
}

extension HomeComponent: AddArticleDependency, RecordDetailDependency {
    var addArticleViewController: RIBs.ViewControllable {
        return rootViewController
    }
}
