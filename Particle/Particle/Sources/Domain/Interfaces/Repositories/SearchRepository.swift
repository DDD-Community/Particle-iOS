//
//  SearchRepository.swift
//  Particle
//
//  Created by 홍석현 on 11/23/23.
//

import Foundation
import RxSwift

protocol SearchRepository {
    func searchArticle(_ text: String) -> Observable<[String]>
}

