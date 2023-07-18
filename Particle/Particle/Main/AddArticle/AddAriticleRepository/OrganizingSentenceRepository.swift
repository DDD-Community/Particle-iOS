//
//  OrganizingSentenceRepository.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import Foundation
import RxSwift
import RxRelay

public protocol OrganizingSentenceRepository {
    var sentenceFile: BehaviorSubject<[String]> { get }
}

public final class OrganizingSentenceRepositoryImp: OrganizingSentenceRepository {
    public var sentenceFile: RxSwift.BehaviorSubject<[String]> {
        sentenceSubject
    }
    
    private let sentenceSubject = BehaviorSubject<[String]>(value: [
        "그렇게 쓴 글은 매일 사회관계망서비스(SNS)에 남기기도 하고, 모아서 책으로 내기도 한다.",
        "개인적으로 나는 매일 글쓰는 일을 습관처럼 하고 있다. ",
        "그러나 처음부터 글을 습관처럼 매일 쓸 수 있었던 건 아니다.",
        "하지만 당시에는 작가가 되고 싶다는 열망 하나를 갖고 있었고, 그 젊은 열망에 따라 어떻게든 무엇이든 글을 쓰고자 했다. ",
        "많은 사람들이 내게 그렇게 매일 글을 쓸 수 있는 비결을 물어보곤 하는데, 나는 그저 습관이 되어버렸다고 말할 수밖에 없다."
    ])
}
