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
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_title02, color: .particleColor.gray05, text: "화면 준비중 입니다.")
        return label
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "탐색"
        tabBarItem.image = .particleImage.exploreTabIcon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        addSubviews()
        setConstraints()
    }
    
    // MARK: - Methods
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Layout Settting

private extension ExploreViewController {
    func addSubviews() {
        [infoLabel].forEach {
            view.addSubview($0)
        }
    }
    
    func setConstraints() {
        infoLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
}
