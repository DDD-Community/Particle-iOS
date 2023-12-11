//
//  SearchByTagUseCase.swift
//  Particle
//
//  Created by Sh Hong on 2023/12/11.
//

import Foundation
import RxSwift

protocol SearchByTagUseCase {
    func execute(tag: String) -> Observable<[SectionOfRecordDate]>
}

final class DefaultSearchByTagUseCase: SearchByTagUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    func execute(tag: String) -> Observable<[SectionOfRecordDate]> {
        recordRepository.getMyRecordsSeparatedByDate(byTag: tag)
    }
    
}
