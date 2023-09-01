//
//  MyPageViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift
import UIKit

protocol MyPagePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MyPageViewController: UIViewController, MyPagePresentable, MyPageViewControllable {

    weak var listener: MyPagePresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "마이"
        tabBarItem.image = .particleImage.mypageTabIcon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .particleColor.main100
    }
}
