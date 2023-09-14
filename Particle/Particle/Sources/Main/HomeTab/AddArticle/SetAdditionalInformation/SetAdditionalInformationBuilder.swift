//
//  SetAdditionalInformationBuilder.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import RIBs

protocol SetAdditionalInformationDependency: Dependency {
    var organizingSentenceRepository: OrganizingSentenceRepository { get }
}

final class SetAdditionalInformationComponent: Component<SetAdditionalInformationDependency> {
    var organizingSentenceRepository: OrganizingSentenceRepository {
        dependency.organizingSentenceRepository
    }
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
        let interactor = SetAdditionalInformationInteractor(
            presenter: viewController,
            repository: component.organizingSentenceRepository
        )
        interactor.listener = listener
        return SetAdditionalInformationRouter(interactor: interactor, viewController: viewController)
    }
}
