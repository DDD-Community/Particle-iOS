//
//  LoggedOutViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift
import SnapKit
import UIKit

protocol LoggedOutPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func login()
}

final class LoggedOutViewController: UIViewController,
                                     LoggedOutPresentable,
                                     LoggedOutViewControllable {
    
    weak var listener: LoggedOutPresentableListener?
    
        label.textColor = .particleColor.white
        label.textColor = .particleColor.white
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .particleColor.black
        
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "LoggedOut RIB"
        label.textColor = .label
        
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("로그인", for: .normal)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        
        view.addSubview(label)
        view.addSubview(button)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        button.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(100)
        }
    }
    
    @objc private func buttonTapped() {
        // TODO: LoggedInRIB 로 Routing
        listener?.login()
    }
}
