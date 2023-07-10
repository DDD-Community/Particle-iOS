//
//  MainTabBarController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift
import UIKit

protocol MainPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MainTabBarController: UITabBarController, MainPresentable, MainViewControllable {
    
    private enum Constant {
        static let HEIGHT_TAB_BAR: CGFloat = 90
    }
    
    weak var listener: MainPresentableListener?
    
    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = Constant.HEIGHT_TAB_BAR
        tabFrame.origin.y = self.view.frame.size.height - Constant.HEIGHT_TAB_BAR
        self.tabBar.frame = tabFrame
    }
    
    private func configureTabBar() {
        let homeVC = HomeViewController()
        let exploreVC = ExploreViewController()
        let searchVC = SearchViewController()
        let mypageVC = MyPageViewController()
        
        homeVC.title = "홈"
        homeVC.tabBarItem.image = UIImage(named: "home")
        
        exploreVC.title = "탐색"
        exploreVC.tabBarItem.image = UIImage(named: "book-open")
        
        searchVC.title = "검색"
        searchVC.tabBarItem.image = UIImage(named: "search")
        
        mypageVC.title = "마이"
        mypageVC.tabBarItem.image = UIImage(named: "user")
        
        let homeNC = UINavigationController(rootViewController: homeVC)
        let exploreNC = UINavigationController(rootViewController: exploreVC)
        let searchNC = UINavigationController(rootViewController: searchVC)
        let mypageNC = UINavigationController(rootViewController: mypageVC)
        
        setViewControllers([homeNC, exploreNC, searchNC, mypageNC], animated: false)
        
        tabBar.backgroundColor = .init(hex: 0x1A1A1A)
        tabBar.tintColor = .init(particleColor: .main)
    }
}
