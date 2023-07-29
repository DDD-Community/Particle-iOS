//
//  SelectSentenceBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/13.
//

import RIBs
import Photos

protocol SelectSentenceDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SelectSentenceComponent: Component<SelectSentenceDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SelectSentenceBuildable: Buildable {
    func build(withListener listener: SelectSentenceListener, images: [PHAsset]) -> SelectSentenceRouting
}

final class SelectSentenceBuilder: Builder<SelectSentenceDependency>, SelectSentenceBuildable {

    override init(dependency: SelectSentenceDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectSentenceListener, images: [PHAsset]) -> SelectSentenceRouting {
        let component = SelectSentenceComponent(dependency: dependency)
        let viewController = SelectSentenceViewController(selectedImages: images)
        let interactor = SelectSentenceInteractor(presenter: viewController)
        interactor.listener = listener
        
        let editSentenceBuilder = EditSentenceBuilder(dependency: component)
        
        return SelectSentenceRouter(
            interactor: interactor,
            viewController: viewController,
            editSentenceBuilder: editSentenceBuilder
        )
    }
}

extension SelectSentenceComponent: EditSentenceDependency, OrganizingSentenceDependency {
    var organizingSentenceRepository: OrganizingSentenceRepository {
        OrganizingSentenceRepositoryImp()
    }
}
