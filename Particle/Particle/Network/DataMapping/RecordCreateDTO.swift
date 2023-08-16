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
    // 가능한 String 값
    // UXUI, BRANDING, GRAPHIC, INDUSTRY, IOS, ANDROID, WEB, SERVER, AI, DATA, HR, TREND, INVEST, GROWTH, CONTENTS
    
    struct RecordItemCreateDTO {
        let content: String
        let isMain: Bool
    }
}
