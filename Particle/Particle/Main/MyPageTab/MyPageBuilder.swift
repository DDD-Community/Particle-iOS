//
//  MyPageBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol MyPageDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MyPageComponent: Component<MyPageDependency>, SetAccountDependency, SetAlarmDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MyPageBuildable: Buildable {
    func build(withListener listener: MyPageListener) -> MyPageRouting
}

final class MyPageBuilder: Builder<MyPageDependency>, MyPageBuildable {

    override init(dependency: MyPageDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyPageListener) -> MyPageRouting {
        let component = MyPageComponent(dependency: dependency)
        let viewController = MyPageViewController()
        let interactor = MyPageInteractor(presenter: viewController)
        interactor.listener = listener
        
        let setAccountBuildable = SetAccountBuilder(dependency: component)
        let setAlarmBuildable = SetAlarmBuilder(dependency: component)
        
        return MyPageRouter(
            interactor: interactor,
            viewController: viewController,
            setAccountBuildable: setAccountBuildable,
            setAlarmBuildable: setAlarmBuildable
        )
    }
}
