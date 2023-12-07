//
//  SearchInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift

protocol SearchRouting: ViewableRouting {
}

protocol SearchPresentable: Presentable {
    var listener: SearchPresentableListener? { get set }
    
    func updateSearchResult(_ result: [SearchResult])
}

protocol SearchListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener {

    weak var router: SearchRouting?
    weak var listener: SearchListener?
    
    private let search: PublishSubject<String>()
    private var disposeBag = DisposeBag()
    
    private let searchUseCase: SearchUseCase
    
    init(
        presenter: SearchPresentable,
        searchUseCase: SearchUseCase
    ) {
        self.searchUseCase = searchUseCase
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        search
            .flatMap(searchUseCase.execute)
            .bind { [weak self] result in
                self?.presenter.updateSearchResult(result)
            }
            .disposed(by: disposeBag)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func requestSearch(_ text: String) {
        search.onNext(text)
    }
}
