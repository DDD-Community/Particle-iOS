//
//  DefaultSearchDataSource.swift
//  Particle
//
//  Created by 홍석현 on 11/23/23.
//

import Foundation
import RxSwift

struct DefaultSearchDataSource: SearchDataSource {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func getSearchResult(_ text: String) -> Observable<[SearchResultDTO]> {
        
        return Observable.just([])
    }
}
