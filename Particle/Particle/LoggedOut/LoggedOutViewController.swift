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
    func login()
}

final class LoggedOutViewController: UIViewController,
                                     LoggedOutPresentable,
                                     LoggedOutViewControllable {
    
    weak var listener: LoggedOutPresentableListener?
    
    // MARK: - UIComponents
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 14
        return stackView
    }()
    
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.text = "나만의 문장을\n잘라 모아 보아요!"
        label.numberOfLines = 0
        label.font = .particleFont.generate(style: .ydeStreetB, size: 25)
        label.textColor = .particleColor.white
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.text = "3초 가입으로 바로 시작해 보세요"
        label.font = .particleFont.generate(style: .pretendard_Medium, size: 16)
        label.textColor = .particleColor.white
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("로그인", for: .normal)
        
        button.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        return button
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .particleImage.loginBackground
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        addSubviews()
        setConstraints()
        configureButton()
    }
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
    }
    
    private func configureButton() {
        loginButton.addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func buttonTapped() {
        // TODO: LoggedInRIB 로 Routing
        listener?.login()
    }
}

// MARK: - Layout Settting

private extension LoggedOutViewController {
    
    func addSubviews() {
        [backgroundImage, titleStackView, buttonStackView].forEach {
            view.addSubview($0)
        }
        
        [mainTitle, subTitle].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [loginButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        backgroundImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(136)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(186)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(56)
            $0.horizontalEdges.equalToSuperview().offset(20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(90)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct LoggedOutViewController_Preview: PreviewProvider {
    static var previews: some View {
        LoggedOutViewController().showPreview()
    }
}
#endif
