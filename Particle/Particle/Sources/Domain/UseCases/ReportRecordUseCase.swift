//
//  ReportRecordUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/12/04.
//

import RxSwift

protocol ReportRecordUseCase {
    func execute(id: String) -> Observable<Bool>
}

final class DefaultReportRecordUseCase: ReportRecordUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    func execute(id: String) -> Observable<Bool> {
        recordRepository.reportRecord(recordId: id)
    }
}

// FIXME: 응답값이 String 확실하지 않음. 뼈대만 구현 
