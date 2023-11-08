//
//  RecordReadDTO.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/16.
//

import Foundation

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
    
    func fetchDateSectionHeaderString() -> String {
        return DateManager.shared.convert(previousDate: createdAt, to: "yyyy년 MM월")
    }
    
    func fetchDate() -> Date {
        return DateManager.shared.convert(dateString: createdAt)
    }
    
    static func stub(id: String = "1") -> Self {
        .init(
            id: id,
            title: "미니멀리스트의 삶",
            url: "www.naver.com",
            items: [
                .stub(content: "개인적으로 나는 매일 글쓰는 일을 습관처럼 하고 있다."),
                .stub(content: "그렇게 쓴 글은 매일 사회관계망서비스(SNS)에 남기기도 하고, 모아서 책으로 내기도 한다.", isMain: true),
                .stub(content: "이런 습관들이 지금의 나를 만들어 줄 수 있었다.")
            ],
            tags: ["iOS"],
            createdAt: "2023-09-30T01:59:05.230Z",
            createdBy: "노란 삼각형"
        )
    }
    
    struct RecordItemReadDTO: Decodable {
        let content: String
        let isMain: Bool
        
        func toDomain() -> (content: String, isMain: Bool) {
            return (content, isMain)
        }
        
        static func stub(content: String = "contentcontentcontent", isMain: Bool = false) -> Self {
            .init(content: content, isMain: isMain)
        }
    }
}
