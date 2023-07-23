//
//  EditSentenceBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol EditSentenceDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class EditSentenceComponent: Component<EditSentenceDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol EditSentenceBuildable: Buildable {
    func build(withListener listener: EditSentenceListener, text: String) -> EditSentenceRouting
}

final class EditSentenceBuilder: Builder<EditSentenceDependency>, EditSentenceBuildable {

    override init(dependency: EditSentenceDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EditSentenceListener, text: String) -> EditSentenceRouting {
        _ = EditSentenceComponent(dependency: dependency)
        let viewController = EditSentenceViewController(with: text) // FIXME: text 데이터 전달과정 리뷰요청. component 활용방법 연구
        let interactor = EditSentenceInteractor(presenter: viewController)
        interactor.listener = listener
        return EditSentenceRouter(interactor: interactor, viewController: viewController)
    }
}
