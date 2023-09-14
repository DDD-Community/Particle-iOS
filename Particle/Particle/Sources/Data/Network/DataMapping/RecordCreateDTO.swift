//
//  RecordCreateDTO.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/16.
//

struct RecordCreateDTO: Codable {
    let title: String
    let url: String
    let items: [RecordItemCreateDTO]
    let tags: [String]
    
    struct RecordItemCreateDTO: Codable {
        let content: String
        let isMain: Bool
        
        func toDictionary() -> Dictionary<String, Any> {
            return [
                "content": content,
                "isMain": isMain
            ]
        }
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        return [
            "title": title,
            "url": url,
            "items": items.map { $0.toDictionary() },
            "tags": tags
        ]
    }
}
