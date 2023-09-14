//
//  RecordReadDTO.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/16.
//

struct RecordReadDTO: Decodable {
    let id: String
    let title: String
    let url: String
    let items: [RecordItemReadDTO]
    let tags: [String]
    let createdAt: String
    let createdBy: String
    
    func toDomain() -> RecordCellModel {
        .init(id: id, createdAt: createdAt, items: items.map { $0.toDomain() }, title: title, url: url)
    }
    
    struct RecordItemReadDTO: Decodable {
        let content: String
        let isMain: Bool
        
        func toDomain() -> (content: String, isMain: Bool) {
            return (content, isMain)
        }
    }
}
