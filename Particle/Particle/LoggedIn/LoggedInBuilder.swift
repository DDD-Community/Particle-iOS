//
//  LoggedInBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol LoggedInDependency: Dependency {
    // TODO: Make sure to convert the variable into lower-camelcase.
    var LoggedInViewController: LoggedInViewControllable { get }
    var organizingSentenceRepository: OrganizingSentenceRepository { get }
}

final class LoggedInComponent: Component<LoggedInDependency>, MainDependency {

    // TODO: Make sure to convert the variable into lower-camelcase.
    fileprivate var LoggedInViewController: LoggedInViewControllable {
        return dependency.LoggedInViewController
    }
    var organizingSentenceRepository: OrganizingSentenceRepository {
        return dependency.organizingSentenceRepository
    }
}

// MARK: - Builder

protocol LoggedInBuildable: Buildable {
    func build(withListener listener: LoggedInListener) -> LoggedInRouting
}

final class LoggedInBuilder: Builder<LoggedInDependency>, LoggedInBuildable {

    override init(dependency: LoggedInDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedInListener) -> LoggedInRouting {
        let component = LoggedInComponent(dependency: dependency)
        let interactor = LoggedInInteractor()
        interactor.listener = listener
        let mainBuilder = MainBuilder(dependency: component)
        return LoggedInRouter(
            interactor: interactor,
            viewController: component.LoggedInViewController,
            mainBuilder: mainBuilder
        )
    }
}
