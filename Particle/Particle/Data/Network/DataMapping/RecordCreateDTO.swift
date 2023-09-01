//
//  RecordCreateDTO.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/16.
//

struct RecordCreateDTO {
    let title: String
    let url: String
    let items: [RecordItemCreateDTO]
    let tags: [String]
    
    struct RecordItemCreateDTO {
        let content: String
        let isMain: Bool
    }
}
