//
//  AddArticleBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol AddArticleDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AddArticleComponent: Component<AddArticleDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AddArticleBuildable: Buildable {
    func build(withListener listener: AddArticleListener) -> AddArticleRouting
}

final class AddArticleBuilder: Builder<AddArticleDependency>, AddArticleBuildable {

    override init(dependency: AddArticleDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddArticleListener) -> AddArticleRouting {
        let component = AddArticleComponent(dependency: dependency)
        let viewController = AddArticleViewController()
        let interactor = AddArticleInteractor(presenter: viewController)
        interactor.listener = listener
        return AddArticleRouter(interactor: interactor, viewController: viewController)
    }
}
