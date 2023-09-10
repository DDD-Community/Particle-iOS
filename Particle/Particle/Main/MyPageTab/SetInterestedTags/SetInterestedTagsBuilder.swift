//
//  SetInterestedTagsBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/10.
//

import RIBs

protocol SetInterestedTagsDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SetInterestedTagsComponent: Component<SetInterestedTagsDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SetInterestedTagsBuildable: Buildable {
    func build(withListener listener: SetInterestedTagsListener) -> SetInterestedTagsRouting
}

final class SetInterestedTagsBuilder: Builder<SetInterestedTagsDependency>, SetInterestedTagsBuildable {

    override init(dependency: SetInterestedTagsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SetInterestedTagsListener) -> SetInterestedTagsRouting {
        let component = SetInterestedTagsComponent(dependency: dependency)
        let viewController = SetInterestedTagsViewController()
        let interactor = SetInterestedTagsInteractor(presenter: viewController)
        interactor.listener = listener
        return SetInterestedTagsRouter(interactor: interactor, viewController: viewController)
    }
}
