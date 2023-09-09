//
//  LoggedOutBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import Alamofire

protocol LoggedOutDependency: Dependency {}

final class LoggedOutComponent: Component<LoggedOutDependency>, SelectTagDependency {}

// MARK: - Builder

protocol LoggedOutBuildable: Buildable {
    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting
}

final class LoggedOutBuilder: Builder<LoggedOutDependency>, LoggedOutBuildable {

    override init(dependency: LoggedOutDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting {
        let component = LoggedOutComponent(dependency: dependency)
        let viewController = LoggedOutViewController()
        let interactor = LoggedOutInteractor(presenter: viewController)
        interactor.listener = listener
        
        let selectTagBuilder = SelectTagBuilder(dependency: component)
        
        return LoggedOutRouter(
            interactor: interactor,
            viewController: viewController,
            selecTagBuilder: selectTagBuilder
        )
    }
}
