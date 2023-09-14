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
    
    weak var router: RecordDetailRouting?
    weak var listener: RecordDetailListener?
    private var disposeBag = DisposeBag()
    
    override init(presenter: RecordDetailPresentable) {
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
        
        return Observable.create { [weak self] emitter in
            guard let self = self else { return Disposables.create() }
            let repo = RecordRepository()
            repo.delete(recordId: id).subscribe { result in
                switch result.element {
                case .success(let response):
                    Console.log(response)
                    emitter.onNext(true)
                case .failure(let error):
                    Console.error(error.localizedDescription)
                    emitter.onNext(false)
                case .none:
                    return
                }
            }
            .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
