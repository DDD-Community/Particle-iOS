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
    func attachMyRecordList(tag: String)
    func detachMyRecordList()
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    
    func setData(data: [SectionOfRecordTag])
}

protocol HomeListener: AnyObject {}

final class HomeInteractor: PresentableInteractor<HomePresentable>,
                            HomeInteractable,
                            HomePresentableListener {
    
    weak var router: HomeRouting?
    weak var listener: HomeListener?
    
    private let fetchMyAllRecordsUseCase: FetchMyAllRecordsUseCase
    private var disposeBag = DisposeBag()
    
    init(
        presenter: HomePresentable,
        fetchMyAllRecordsUseCase: FetchMyAllRecordsUseCase
    ) {
        self.fetchMyAllRecordsUseCase = fetchMyAllRecordsUseCase
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        fetchData()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: - HomePresentableListener
    
    func homeCellTapped(with model: RecordReadDTO) {
        router?.attachRecordDetail(data: model)
    }
    
    func homePlusButtonTapped() {
        router?.attachAddArticle()
    }
    
    func homeSectionTitleTapped(tag: String) {
        router?.attachMyRecordList(tag: tag)
    }
    
    // MARK: - HomeInteractable
    
    func recordDetailCloseButtonTapped() {
        router?.detachAddArticle()
        router?.detachRecordDetail()
        fetchData()
    }
    
    func myRecordListBackButtonTapped() {
        router?.detachMyRecordList()
    }

    // MARK: - Methods
    
    private func fetchData() {
        fetchMyAllRecordsUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] data in
                self?.presenter.setData(data: data)
            } onError: { error in
                Console.error(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
