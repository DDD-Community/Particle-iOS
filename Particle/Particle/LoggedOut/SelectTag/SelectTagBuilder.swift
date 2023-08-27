//
//  SelectTagBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/24.
//

import RIBs

protocol SelectTagDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SelectTagComponent: Component<SelectTagDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SelectTagBuildable: Buildable {
    func build(withListener listener: SelectTagListener) -> SelectTagRouting
}

final class SelectTagBuilder: Builder<SelectTagDependency>, SelectTagBuildable {

    override init(dependency: SelectTagDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectTagListener) -> SelectTagRouting {
        let component = SelectTagComponent(dependency: dependency)
        let viewController = SelectTagViewController()
        let interactor = SelectTagInteractor(presenter: viewController)
        interactor.listener = listener
        return SelectTagRouter(interactor: interactor, viewController: viewController)
    }
}
