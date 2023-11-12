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
    
    private let deleteRecordUseCase: DeleteRecordUseCase
    
    weak var router: RecordDetailRouting?
    weak var listener: RecordDetailListener?
    private var disposeBag = DisposeBag()
    
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
    
    func recordDetailDeleteButtonTapped(with id: String) -> Observable<Bool> {
        
        deleteRecordUseCase.execute(id: id)
            .map { response in
                return response == id /// 성공/실패시 나타나는 string 값 뭔지 모름.
            }
        
        
        // TODO: Listener 로 보내서 MyRecordList RIB 에서도 리프레쉬 되도록 구현해야 함.
    }
    
    func newRecordDetailDeleteButtonTapped(with id: String) {
        deleteRecordUseCase.newExecute(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] data in

                if (200..<300).contains(data.status) {
                    self?.presenter.showSuccessAlert()
                } else {
                    self?.presenter.showErrorAlert(description: "status: \(data.status)\ncode:\(data.code)\nmessage: \(data.message)")
                }
            } onError: { [weak self] error in
                /// 회원탈퇴 에러??
                self?.presenter.showErrorAlert(description: error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
