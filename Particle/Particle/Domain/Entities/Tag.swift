//
//  Tag.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/01.
//

import Foundation

enum Tag: String {
    case branding = "#브랜딩"
    case uxui = "#UXUI"
    case graphic = "#그래픽 디자인"
    case industry = "#산업 디자인"
    case ios = "#iOS"
    case android = "#Android"
    case web = "#Web"
    case server = "#서버"
    case ai = "#AI"
    case service_plan = "#서비스 기획"
    case strategy_plan = "#전략 기획"
    case system_plan = "#시스템 기획"
    case data_anal = "#데이터 분석"
    case company_culture = "#조직 문화"
    case trend = "#트랜드"
    case cx = "#CX"
    case leadership = "#리더쉽"
    case insight = "#인사이트"
    case branding_marketing = "#브랜드 마케팅"
    case growth_marketing = "#그로스 마케팅"
    case contents_marketing = "#콘텐츠 마케팅"

    var value: String {
        switch self {
        case .branding:
            return "BRANDING"
        case .uxui:
            return "UXUI"
        case .graphic:
            return "GRAPHIC"
        case .industry:
            return "INDUSTRY"
        case .ios:
            return "IOS"
        case .android:
            return "ANDROID"
        case .web:
            return "WEB"
        case .server:
            return "SERVER"
        case .ai:
            return "AI"
        case .service_plan:
            return "SERVICE_PLAN"
        case .strategy_plan:
            return "STRATEGY_PLAN"
        case .system_plan:
            return "SYSTEM_PLAN"
        case .data_anal:
            return "DATA_ANAL"
        case .company_culture:
            return "COMPANY_CULTURE"
        case .trend:
            return "TREND"
        case .cx:
            return "CX"
        case .leadership:
            return "LEADERSHIP"
        case .insight:
            return "INSIGHT"
        case .branding_marketing:
            return "BRANDING_MARKETING"
        case .growth_marketing:
            return "GROWTH_MARKETING"
        case .contents_marketing:
            return "CONTENTS_MARKETING"
        }
    }
}
