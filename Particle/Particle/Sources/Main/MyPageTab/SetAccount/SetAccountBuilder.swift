//
//  SetAccountBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs

protocol SetAccountDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SetAccountComponent: Component<SetAccountDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SetAccountBuildable: Buildable {
    func build(withListener listener: SetAccountListener) -> SetAccountRouting
}

final class SetAccountBuilder: Builder<SetAccountDependency>, SetAccountBuildable {

    override init(dependency: SetAccountDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SetAccountListener) -> SetAccountRouting {
        let component = SetAccountComponent(dependency: dependency)
        let viewController = SetAccountViewController()
        let interactor = SetAccountInteractor(presenter: viewController)
        interactor.listener = listener
        return SetAccountRouter(interactor: interactor, viewController: viewController)
    }
}
