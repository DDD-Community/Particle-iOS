//
//  MyRecordListInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/03.
//

import RIBs
import RxSwift

protocol MyRecordListRouting: ViewableRouting {}

protocol MyRecordListPresentable: Presentable {
    var listener: MyRecordListPresentableListener? { get set }
    
    func setData(with data: [SectionOfRecordDate])
}

protocol MyRecordListListener: AnyObject {
    func myRecordListBackButtonTapped()
}

final class MyRecordListInteractor: PresentableInteractor<MyRecordListPresentable>,
                                    MyRecordListInteractable,
                                    MyRecordListPresentableListener {
    
    private let tag: String
    private var disposeBag = DisposeBag()
    private var sortedByRecentRecords: [SectionOfRecordDate] = []
    private var sortedByOldRecords: [SectionOfRecordDate] = []
    weak var router: MyRecordListRouting?
    weak var listener: MyRecordListListener?

    init(presenter: MyRecordListPresentable, tag: String) {
        self.tag = tag
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
    
    // MARK: - Methods
    
    private func fetchData() {
        
        if tag == "My" {
            fetchAllRecords()
        } else {
            fetchRecordsFromTag()
        }
    }
    
    private func fetchAllRecords() {
        let repo = RecordRepository()
        repo.readMyRecord().subscribe { [weak self] result in
            guard let self = self else { return }
            switch result.element {
            case .success(let dto):
                Console.log("Success \(#function)")
                
                let data = self.mapDTO(dto: dto)
                self.sortedByRecentRecords = data
                self.sortedByOldRecords = reverseRecords(data: data)
                self.presenter.setData(with: data)
            case .failure(let error):
                Console.error(error.localizedDescription)
            case .none:
                return
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func fetchRecordsFromTag() {
        let repo = RecordRepository()
        repo.read(byTag: tag).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result.element {
            case .success(let dto):
                Console.log("Success \(#function)")
                let data = self.mapDTO(dto: dto)
                self.sortedByRecentRecords = data
                self.sortedByOldRecords = reverseRecords(data: data)
                self.presenter.setData(with: data)
            case .failure(let error):
                Console.error(error.localizedDescription)
            case .none:
                return
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func mapDTO(dto: [RecordReadDTO]) ->  [SectionOfRecordDate] {
        var list = dto
        list.sort { a, b in
            a.fetchDate().timeIntervalSince1970 > b.fetchDate().timeIntervalSince1970
        }
        
        var headers = [String]()
        
        for ele in list {
            let header = ele.fetchDateSectionHeaderString()
            if headers.contains(header) {
                continue
            } else {
                headers.append(header)
            }
        }
        
        var result = [SectionOfRecordDate]()
        
        for header in headers {
            result.append(
                .init(
                    header: header,
                    items: list.filter { $0.fetchDateSectionHeaderString() == header }
                )
            )
        }
        
        return result
    }
    
    private func reverseRecords(data: [SectionOfRecordDate]) -> [SectionOfRecordDate] {
        var newList = [SectionOfRecordDate]()
        for record in data.reversed() {
            newList.append(record.reverseItems())
        }
        return newList
    }
    
    // MARK: - MyRecordListPresentableListener
    
    func myRecordListBackButtonTapped() {
        listener?.myRecordListBackButtonTapped()
    }
    
    func myRecordSorByRecentButtonTapped() {
        self.presenter.setData(with: sortedByRecentRecords)
    }
    
    func myRecordSorByOldButtonTapped() {
        self.presenter.setData(with: sortedByOldRecords)
    }
}
