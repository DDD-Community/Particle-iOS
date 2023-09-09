//
//  HomeInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift

protocol HomeRouting: ViewableRouting {
    func attachAddArticle()
    func detachAddArticle()
    func attachRecordDetail(data: RecordReadDTO)
    func detachRecordDetail()
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    
    func setData(data: [RecordReadDTO])
}

protocol HomeListener: AnyObject {}

final class HomeInteractor: PresentableInteractor<HomePresentable>,
                            HomeInteractable,
                            HomePresentableListener {
    
    weak var router: HomeRouting?
    weak var listener: HomeListener?
    
    private var disposeBag = DisposeBag()
    
    override init(presenter: HomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // 데이터 받아오기?
        let repo = RecordRepository()
        repo.readMyRecord().subscribe { [weak self] result in
            switch result.element {
            case .success(let dto):
                self?.presenter.setData(data: dto)
            case .failure(let error):
                Console.error(error.localizedDescription)
            case .none:
                return
            }
        }
        .disposed(by: disposeBag)

    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: - HomePresentableListener
    
    func cellTapped(with model: RecordReadDTO) {
        router?.attachRecordDetail(data: model)
    }
    
    func showPHPickerViewController() {
        router?.attachAddArticle()
    }
    
    func dismiss() {
        router?.detachAddArticle()
    }
    
    
    func recordDetailCloseButtonTapped() {
        router?.detachAddArticle()
        router?.detachRecordDetail()
        
        let repo = RecordRepository()
        repo.readMyRecord().subscribe { [weak self] result in
            switch result.element {
            case .success(let dto):
                self?.presenter.setData(data: dto)
            case .failure(let error):
                Console.error(error.localizedDescription)
            case .none:
                return
            }
        }
        .disposed(by: disposeBag)
    }
}
