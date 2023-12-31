//
//  ParticleServer.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/10.
//

enum ParticleServer {
    static let baseURL = "https://particle.k-net.kr"
    
    enum Version: String {
        case v1 = "api/v1"
    }
    
    enum Path {
        case createRecord
        case deleteRecord(id: String)
        case readMyRecords
        case searchByTitle
        case searchByTag
        case readMyProfile
        case setInterestedTags
        case login
        case withdraw
        
        var value: String {
            switch self {
            case .createRecord:
                return "/record"
            case .deleteRecord(let id):
                return "/record/\(id)"
            case .readMyRecords:
                return "/record/my"
            case .searchByTitle:
                return "/record/search/by/title-and-content"
            case .searchByTag:
                return "/record/search/by/tag"
            case .readMyProfile:
                return "/user/my/profile"
            case .setInterestedTags:
                return "/user/interested/tags"
            case .login:
                return "/auth/login"
            case .withdraw:
                return "/auth/withdrawal"
            }
        }
    }
}
