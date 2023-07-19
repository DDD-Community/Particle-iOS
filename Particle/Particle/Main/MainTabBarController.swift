//
//  MainTabBarController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift
import UIKit
import RxCocoa
import SnapKit

protocol MainPresentableListener: AnyObject {

}

final class MainTabBarController: UITabBarController, MainPresentable, MainViewControllable {
    
    private enum Metric {
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
        tabFrame.size.height = Metric.HEIGHT_TAB_BAR
        tabFrame.origin.y = self.view.frame.size.height - Metric.HEIGHT_TAB_BAR
        self.tabBar.frame = tabFrame
    }
    
    private func configureTabBar() {
        tabBar.backgroundColor = .init(hex: 0x1A1A1A)
        tabBar.tintColor = .init(particleColor: .main)
    }
    
    func present(viewController: RIBs.ViewControllable) {
        present(viewController.uiviewController, animated: true)
    }
    
    func setViewControllers(_ viewControllers: [ViewControllable]) {
      super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
    }
    
}
