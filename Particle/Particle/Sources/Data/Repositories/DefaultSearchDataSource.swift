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
        let path = ParticleServer.Version.v1.rawValue + ParticleServer.Path.searchByTitle.value
        
        let endpoint = Endpoint<[SearchResultDTO]>(
            path: path,
            method: .get,
            headerParameters: ["Authorization": "Bearer \(UserDefaults.standard.string(forKey: "ACCESSTOKEN") ?? "")"],
            queryParameters: ["title": text]
        )
        
        return dataTransferService.request(with: endpoint)
    }
}
