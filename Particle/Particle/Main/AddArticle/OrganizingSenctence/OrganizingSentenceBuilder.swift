//
//  OrganizingSentenceBuilder.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/11.
//

import RIBs

protocol OrganizingSentenceDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class OrganizingSentenceComponent: Component<OrganizingSentenceDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol OrganizingSentenceBuildable: Buildable {
    func build(withListener listener: OrganizingSentenceListener) -> OrganizingSentenceRouting
}

final class OrganizingSentenceBuilder: Builder<OrganizingSentenceDependency>, OrganizingSentenceBuildable {

    override init(dependency: OrganizingSentenceDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: OrganizingSentenceListener) -> OrganizingSentenceRouting {
        let component = OrganizingSentenceComponent(dependency: dependency)
        let viewController = OrganizingSentenceViewController()
        let interactor = OrganizingSentenceInteractor(presenter: viewController)
        interactor.listener = listener
        return OrganizingSentenceRouter(interactor: interactor, viewController: viewController)
    }
}
