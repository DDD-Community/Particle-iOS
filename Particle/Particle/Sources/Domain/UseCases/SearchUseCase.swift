//
//  SearchUseCase.swift
//  Particle
//
//  Created by 홍석현 on 11/23/23.
//

import Foundation
import RxSwift

protocol SearchUseCase {
    func execute(_ text: String) -> Observable<[SearchResult]>
}

final class DefaultSearchResultUseCase: SearchUseCase {
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func execute(_ text: String) -> Observable<[SearchResult]> {
        return searchRepository.searchArticle(text)
    }
}
