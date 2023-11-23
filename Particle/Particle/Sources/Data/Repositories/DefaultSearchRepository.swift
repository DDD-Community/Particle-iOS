//
//  DefaultSearchRepository.swift
//  Particle
//
//  Created by 홍석현 on 11/23/23.
//

import RxSwift

struct DefaultSearchRepository: SearchRepository {
    func searchArticle(_ text: String) -> Observable<[String]> {
        return Observable.just(["fdjskafjsd"])
    }
}
