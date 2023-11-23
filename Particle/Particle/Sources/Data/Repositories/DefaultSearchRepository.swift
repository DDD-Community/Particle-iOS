//
//  DefaultSearchRepository.swift
//  Particle
//
//  Created by 홍석현 on 11/23/23.
//

import RxSwift

struct DefaultSearchRepository: SearchRepository {
    private let searchDataSource: SearchDataSource
    
    init(
        searchDataSource: SearchDataSource
    ) {
        self.searchDataSource = searchDataSource
    }
    
    func searchArticle(_ text: String) -> Observable<[SearchResult]> {
        return searchDataSource.getSearchResult(text)
            .map { $0.toDomain() }
    }
}
