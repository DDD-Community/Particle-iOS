//
//  RecordDetailInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/02.
//

import RIBs
import RxSwift

protocol RecordDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RecordDetailPresentable: Presentable {
    var listener: RecordDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func showErrorAlert(description: String)
    func showSuccessAlert()
}

protocol RecordDetailListener: AnyObject {
    func recordDetailCloseButtonTapped()
}

final class RecordDetailInteractor: PresentableInteractor<RecordDetailPresentable>,
                                    RecordDetailInteractable,
                                    RecordDetailPresentableListener {
        
    weak var router: RecordDetailRouting?
    weak var listener: RecordDetailListener?
    private var disposeBag = DisposeBag()
    private let deleteRecordUseCase: DeleteRecordUseCase
    
    init(
        presenter: RecordDetailPresentable,
        deleteRecordUseCase: DeleteRecordUseCase
    ) {
        self.deleteRecordUseCase = deleteRecordUseCase
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - RecordDetailPresentableListener
    
    func recordDetailCloseButtonTapped() {
        listener?.recordDetailCloseButtonTapped()
    }
    
    func recordDetailDeleteButtonTapped(with id: String) {
        deleteRecordUseCase.execute(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] deletedRecordId in
                if id == deletedRecordId {
                    self?.presenter.showSuccessAlert()
                    // TODO: Listener 로 보내서 MyRecordList RIB 에서도 리프레쉬 되도록 구현해야 함.
                }
            } onError: { [weak self] error in
                if case DataTransferError.resolvedNetworkFailure(let errorResponse as ErrorResponse) = error {
                    self?.presenter.showErrorAlert(description: errorResponse.toDomain())
                } else {
                    self?.presenter.showErrorAlert(description: "알 수 없는 에러가 발생했습니다.\n다시 시도해주세요\n\(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
    }
}
