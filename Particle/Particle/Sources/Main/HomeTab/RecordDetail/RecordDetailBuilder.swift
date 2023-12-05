//
//  RecordDetailBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/02.
//

import RIBs

protocol RecordDetailDependency: Dependency {
    var recordRepository: RecordRepository { get }
}

final class RecordDetailComponent: Component<RecordDetailDependency> {

    fileprivate var deleteRecordUseCase: DeleteRecordUseCase {
        return DefaultDeleteRecordUseCase(recordRepository: dependency.recordRepository)
    }
    
    fileprivate var reportRecordUseCase: ReportRecordUseCase {
        return DefaultReportRecordUseCase(recordRepository: dependency.recordRepository)
    }
}

// MARK: - Builder

protocol RecordDetailBuildable: Buildable {
    func build(
        withListener listener: RecordDetailListener,
        data: RecordReadDTO) -> RecordDetailRouting
}

final class RecordDetailBuilder: Builder<RecordDetailDependency>, RecordDetailBuildable {

    override init(dependency: RecordDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordDetailListener,
               data: RecordReadDTO) -> RecordDetailRouting {
        
        let component = RecordDetailComponent(dependency: dependency)
        let viewController = RecordDetailViewController(data: data)
        let interactor = RecordDetailInteractor(
            presenter: viewController,
            deleteRecordUseCase: component.deleteRecordUseCase,
            reportRecordUseCase: component.reportRecordUseCase
        )
        interactor.listener = listener
        return RecordDetailRouter(interactor: interactor, viewController: viewController)
    }
}
