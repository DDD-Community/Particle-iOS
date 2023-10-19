//
//  DefaultRecordDataSource.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/09.
//

import Foundation
import RxSwift

final class DefaultRecordDataSource: RecordDataSource {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func getMyRecords() -> RxSwift.Observable<[RecordReadDTO]> {
        
        let path = ParticleServer.Version.v1.rawValue
        + ParticleServer.Path.readMyRecords.value
        
        let endpoint = Endpoint<[RecordReadDTO]>(
            path: path,
            method: .get
        )
        return dataTransferService.request(with: endpoint)
    }
    
    func getRecordsBy(tag: String) -> RxSwift.Observable<[RecordReadDTO]> {
        
        let path = ParticleServer.Version.v1.rawValue
        + ParticleServer.Path.searchByTag(tag: tag).value
        
        let endpoint = Endpoint<[RecordReadDTO]>(
            path: path,
            method: .get
        )
        return dataTransferService.request(with: endpoint)
    }
    
    func createRecord(record: RecordCreateDTO) -> RxSwift.Observable<RecordReadDTO> {
        
        let path = ParticleServer.Version.v1.rawValue
        + ParticleServer.Path.createRecord.value
        
        let endpoint = Endpoint<RecordReadDTO>(
            path: path,
            method: .post,
            queryParametersEncodable: record
        )
        return dataTransferService.request(with: endpoint)
    }
    
    func deleteRecord(recordId: String) -> RxSwift.Observable<String> {
        let path = ParticleServer.Version.v1.rawValue
        + ParticleServer.Path.deleteRecord(id: recordId).value
        
        let endpoint = Endpoint<String>(
            path: path,
            method: .delete
        )
        return dataTransferService.request(with: endpoint)
    }
}
