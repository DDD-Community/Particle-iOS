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
            .map { str in
                return str == "성공" /// 성공/실패시 나타나는 string 값 뭔지 모름.
            }
        
        
        // TODO: Listener 로 보내서 MyRecordList RIB 에서도 리프레쉬 되도록 구현해야 함.
//        return Observable.create { [weak self] emitter in
//            guard let self = self else { return Disposables.create() }
//            remoteRepository.deleteRecord(recordId: id)
//                .subscribe { result in
//                    emitter.onNext(true)
//                } onError: { error in
//                    Console.error(error.localizedDescription)
//                    emitter.onNext(false)
//                }
//                .disposed(by: disposeBag)

//            let repo = RecordRepository()
//            repo.delete(recordId: id).subscribe { result in
//                switch result.element {
//                case .success(let response):
//                    Console.log(response)
//                    emitter.onNext(true)
//                case .failure(let error):
//                    Console.error(error.localizedDescription)
//                    emitter.onNext(false)
//                case .none:
//                    return
//                }
//            }
//            .disposed(by: self.disposeBag)
            
//            return Disposables.create()
//        }
    }
}
