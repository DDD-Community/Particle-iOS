//
//  SectionOfRecord.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/01.
//

import RxDataSources

struct SectionOfRecord {
    var header: String
    var items: [Item]
}

extension SectionOfRecord: SectionModelType {
    typealias Item = RecordReadDTO
    
    init(original: SectionOfRecord, items: [RecordReadDTO]) {
        self = original
        self.items = items
    }
}
