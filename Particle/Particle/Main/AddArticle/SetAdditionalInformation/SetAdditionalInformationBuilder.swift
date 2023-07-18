//
//  SetAdditionalInformationBuilder.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import RIBs

protocol SetAdditionalInformationDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SetAdditionalInformationComponent: Component<SetAdditionalInformationDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SetAdditionalInformationBuildable: Buildable {
    func build(withListener listener: SetAdditionalInformationListener) -> SetAdditionalInformationRouting
}

final class SetAdditionalInformationBuilder: Builder<SetAdditionalInformationDependency>, SetAdditionalInformationBuildable {

    override init(dependency: SetAdditionalInformationDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SetAdditionalInformationListener) -> SetAdditionalInformationRouting {
        let component = SetAdditionalInformationComponent(dependency: dependency)
        let viewController = SetAdditionalInformationViewController()
        let interactor = SetAdditionalInformationInteractor(presenter: viewController)
        interactor.listener = listener
        return SetAdditionalInformationRouter(interactor: interactor, viewController: viewController)
    }
}
