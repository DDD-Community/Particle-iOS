//
//  ExploreViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift
import UIKit

protocol ExplorePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ExploreViewController: UIViewController, ExplorePresentable, ExploreViewControllable {

    weak var listener: ExplorePresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "탐색"
        tabBarItem.image = .particleImage.exploreTabIcon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .particleColor.main
    }
}
