//
//  RecordReadDTO.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/16.
//

struct RecordReadDTO {
    let id: String
    let title: String
    let url: String
    let items: [RecordItemReadDTO]
    let tags: [String]
    let createdAt: String
    let createdBy: String
    
    struct RecordItemReadDTO {
        let content: String
        let isMain: Bool
    }
}


