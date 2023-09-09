//
//  RecordDetailBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/02.
//

import RIBs

protocol RecordDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RecordDetailComponent: Component<RecordDetailDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RecordDetailBuildable: Buildable {
    func build(withListener listener: RecordDetailListener, data: RecordReadDTO) -> RecordDetailRouting
}

final class RecordDetailBuilder: Builder<RecordDetailDependency>, RecordDetailBuildable {

    override init(dependency: RecordDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordDetailListener, data: RecordReadDTO) -> RecordDetailRouting {
        let _ = RecordDetailComponent(dependency: dependency)
        let viewController = RecordDetailViewController(data: data)
        let interactor = RecordDetailInteractor(presenter: viewController)
        interactor.listener = listener
        return RecordDetailRouter(interactor: interactor, viewController: viewController)
    }
}
