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
    func attachMyRecordList()
    func detachMyRecordList()
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    
    func setData(data: [SectionOfRecord])
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
        
        let repo = RecordRepository()
        repo.readMyRecord().subscribe { [weak self] result in
            guard let self = self else { return }
            switch result.element {
            case .success(let dto):
                let data = self.mapDTO(data: dto)
                self.presenter.setData(data: data)
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
    
    func homeCellTapped(with model: RecordReadDTO) {
        router?.attachRecordDetail(data: model)
    }
    
    func homePlusButtonTapped() {
        router?.attachAddArticle()
    }
    
    func homeSectionTitleTapped() {
        router?.attachMyRecordList()
    }
    
    // MARK: - HomeInteractable
    
    func recordDetailCloseButtonTapped() {
        router?.detachAddArticle()
        router?.detachRecordDetail()
        
        let repo = RecordRepository()
        repo.readMyRecord().subscribe { [weak self] result in
            guard let self = self else { return }
            switch result.element {
            case .success(let dto):
                let data = self.mapDTO(data: dto)
                self.presenter.setData(data: data)
            case .failure(let error):
                Console.error(error.localizedDescription)
            case .none:
                return
            }
        }
        .disposed(by: disposeBag)
    }
    
    func myRecordListBackButtonTapped() {
        router?.detachMyRecordList()
    }

    // MARK: - Methods
    
    private func mapDTO(data: [RecordReadDTO]) -> [SectionOfRecord] {
        guard let userInterestedTags = UserDefaults.standard.object(forKey: "INTERESTED_TAGS") as? [String] else {
            return []
        }
        var sectionList: [SectionOfRecord] = [.init(header: "My", items: data)]
        let tags = userInterestedTags.map { $0.replacingOccurrences(of: "#", with: "")}
        for tag in tags {
            let filteredList = data.filter { $0.tags.contains(tag) }
            if filteredList.isEmpty == false {
                sectionList.append(.init(header: tag, items: filteredList))
            }
        }
        return sectionList
    }
}
