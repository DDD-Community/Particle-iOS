//
//  DeleteRecordUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/15.
//

import RxSwift

protocol DeleteRecordUseCase {
    func execute(id: String) -> Observable<String>
    func newExecute(id: String) -> Observable<DeleteRecordResponse>
}

final class DefaultDeleteRecordUseCase: DeleteRecordUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    func execute(id: String) -> Observable<String> {
        recordRepository.deleteRecord(recordId: id)
    }
    
    func newExecute(id: String) -> Observable<DeleteRecordResponse> {
        recordRepository.newDeleteRecord(recordId: id)
    }
}
