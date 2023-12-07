//
//  SearchBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol SearchDependency: Dependency {
    var searchRepository: SearchRepository { get }
}

final class SearchComponent: Component<SearchDependency> {

    fileprivate var searchUseCase: SearchUseCase {
        return DefaultSearchResultUseCase(searchRepository: dependency.searchRepository)
    }
}

// MARK: - Builder

protocol SearchBuildable: Buildable {
    func build(withListener listener: SearchListener) -> SearchRouting
}

final class SearchBuilder: Builder<SearchDependency>, SearchBuildable {

    override init(dependency: SearchDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchListener) -> SearchRouting {
        let component = SearchComponent(dependency: dependency)
        
        let viewController = SearchViewController()
        let interactor = SearchInteractor(
            presenter: viewController,
            searchUseCase: component.searchUseCase
        )
        interactor.listener = listener
        return SearchRouter(interactor: interactor, viewController: viewController)
    }
}
