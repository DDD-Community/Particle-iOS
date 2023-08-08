//
//  AddArticleBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol AddArticleDependency: Dependency {
    // TODO: Make sure to convert the variable into lower-camelcase.
    var addArticleViewController: ViewControllable { get }
    // TODO: Declare the set of dependencies required by this RIB, but won't be
    // created by this RIB.
}

final class AddArticleComponent: Component<AddArticleDependency> {

    var repository = OrganizingSentenceRepositoryImp()
    // TODO: Make sure to convert the variable into lower-camelcase.
    fileprivate var addArticleViewController: ViewControllable {
        return dependency.addArticleViewController
    }

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AddArticleBuildable: Buildable {
    func build(withListener listener: AddArticleListener) -> AddArticleRouting
}

final class AddArticleBuilder: Builder<AddArticleDependency>, AddArticleBuildable {

    override init(dependency: AddArticleDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddArticleListener) -> AddArticleRouting {
        let component = AddArticleComponent(dependency: dependency)
        let interactor = AddArticleInteractor()
        interactor.listener = listener
        
        let photoPickerBuilder = PhotoPickerBuilder(dependency: component)
        let selectSentenceBuilder = SelectSentenceBuilder(dependency: component)
        let organizingSentenceBuilder = OrganizingSentenceBuilder(dependency: component)
        let setAdditionalInformationBuilder = SetAdditionalInformationBuilder(dependency: component)
        
        return AddArticleRouter(
            interactor: interactor,
            viewController: component.addArticleViewController,
            photoPickerBuildable: photoPickerBuilder,
            selectSentenceBuildable: selectSentenceBuilder,
            organizingSentenceBuildable: organizingSentenceBuilder,
            setAdditionalInformationBuildable: setAdditionalInformationBuilder
        )
    }
}

extension AddArticleComponent: PhotoPickerDependency,
                               SelectSentenceDependency,
                               OrganizingSentenceDependency,
                               SetAdditionalInformationDependency {
    
    var organizingSentenceRepository: OrganizingSentenceRepository {
        return repository
    }
}
