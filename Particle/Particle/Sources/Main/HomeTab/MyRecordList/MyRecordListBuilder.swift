//
//  MyRecordListBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/03.
//

import RIBs

protocol MyRecordListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MyRecordListComponent: Component<MyRecordListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MyRecordListBuildable: Buildable {
    func build(withListener listener: MyRecordListListener, tag: String) -> MyRecordListRouting
}

final class MyRecordListBuilder: Builder<MyRecordListDependency>, MyRecordListBuildable {

    override init(dependency: MyRecordListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyRecordListListener, tag: String) -> MyRecordListRouting {
        let component = MyRecordListComponent(dependency: dependency)
        let viewController = MyRecordListViewController()
        let interactor = MyRecordListInteractor(presenter: viewController, tag: tag)
        interactor.listener = listener
        
        let recordDetailBuilder = RecordDetailBuilder(dependency: component)
        
        return MyRecordListRouter(
            interactor: interactor,
            viewController: viewController,
            recordDetailBuildable: recordDetailBuilder
        )
    }
}

extension MyRecordListComponent: RecordDetailDependency {
    
}
