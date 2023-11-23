//
//  SearchDataSource.swift
//  Particle
//
//  Created by 홍석현 on 11/23/23.
//

import Foundation
import RxSwift

protocol SearchDataSource {
    func getSearchResult(_ text: String) -> Observable<[SearchResultDTO]>
}
