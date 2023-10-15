//
//  DefaultUserDataSource.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/10.
//

import Foundation
import RxSwift

final class DefaultUserDataSource: UserDataSource {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func getMyProfile() -> RxSwift.Observable<UserReadDTO> {
        let path = ParticleServer.Version.v1.rawValue
        + ParticleServer.Path.readMyProfile.value
        
        let endpoint = Endpoint<UserReadDTO>(
            path: path,
            method: .get
        )
        
        return dataTransferService.request(with: endpoint)
    }
    
    func setInterestedTags(tags: [String]) -> RxSwift.Observable<UserReadDTO> {
        
        var queryParameters = ""
        tags.forEach {
            queryParameters += "interestedTags=\($0)&"
        }
        _ = queryParameters.popLast()
        /// dictionary로 형성하면 key 값이 interestedTags로 모두 같아서 형성 불가..
        let path = ParticleServer.Version.v1.rawValue
        + ParticleServer.Path.setInterestedTags.value
        + queryParameters
        
        let endpoint = Endpoint<UserReadDTO>(
            path: path,
            method: .post
        )
        
        return dataTransferService.request(with: endpoint)
    }
}
