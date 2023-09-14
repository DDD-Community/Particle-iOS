//
//  SearchViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift
import UIKit

protocol SearchPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {

    weak var listener: SearchPresentableListener?
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_title02, color: .particleColor.gray05, text: "화면 준비중 입니다.")
        return label
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "검색"
        tabBarItem.image = .particleImage.searchTabIcon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        addSubviews()
        setConstraints()
    }
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Layout Settting

private extension SearchViewController {
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
