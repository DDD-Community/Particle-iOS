//
//  AppComponent.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

class AppComponent: Component<EmptyComponent>, RootDependency {
    
    init() {
        super.init(dependency: EmptyComponent())
    }
}
