//
//  LoggedOutViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift
import SnapKit
import KakaoSDKUser

import UIKit

protocol LoggedOutPresentableListener: AnyObject {
    func successLogin()
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable{
    
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
    
    private let kakaoLoginButton: UIView = {
        let button = UIView()
        button.backgroundColor = .init(hex: 0xFEE500)
        button.layer.cornerRadius = 8
        
        button.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        let imageView = UIImageView()
        imageView.image = .particleImage.kakaoLogo
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        let title = UILabel()
        title.text = "카카오 로그인"
        title.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        title.textColor = .init(hex: 0x191919)
        
        let stack = UIStackView(arrangedSubviews: [imageView, title])
        stack.axis = .horizontal
        stack.spacing = 6
        
        [stack].forEach {
            button.addSubview($0)
        }
        
        stack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        return button
    }()
    
    private let appleLoginButton: UIView = {
        let button = UIView()
        button.backgroundColor = .init(hex: 0x000000)
        button.layer.cornerRadius = 8
        
        button.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        let imageView = UIImageView()
        imageView.image = .particleImage.appleLogo
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        let title = UILabel()
        title.text = "Apple 로그인"
        title.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        title.textColor = .init(hex:0xFFFFFF)
        
        let stack = UIStackView(arrangedSubviews: [imageView, title])
        stack.axis = .horizontal
        stack.spacing = 6
        
        [stack].forEach {
            button.addSubview($0)
        }
        
        stack.snp.makeConstraints {
            $0.center.equalToSuperview()
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
    
    func present(viewController: ViewControllable) {
        present(viewController, animated: true, completion: nil)
    }
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
    }
    
    private func configureButton() {
        let kakaoLoginButtonTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(kakaoLoginButtonTapped)
        )
        
        kakaoLoginButton.addGestureRecognizer(kakaoLoginButtonTapGesture)
        
        let appleLoginButtonTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(appleLoginButtonTapped)
        )
        appleLoginButton.addGestureRecognizer(appleLoginButtonTapGesture)
    }
    
    @objc
    private func appleLoginButtonTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc
    private func kakaoLoginButtonTapped() {
        Console.debug(#function)
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    Console.error(error.localizedDescription)
                } else {
                    Console.log("loginWithKakaoTalk() success")
                    _ = oauthToken?.accessToken
                    self?.listener?.successLogin()
                    // TODO: accessToken 을 Particle 가입 Identifier로 사용?
                }
            }
        } else {
            Console.error("카카오톡이 설치되어있지 않습니다.")
            loginKakaoAccount()
        }
    }
    
    private func loginKakaoAccount() {
        Console.log(#function)
        
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            if let error = error {
                Console.error(error.localizedDescription)
            } else {
                Console.log("\(#function) success.")
                _ = oauthToken?.accessToken
                self?.listener?.successLogin()
            }
        }
    }
}

// MARK: - Apple Login

extension LoggedOutViewController: ASAuthorizationControllerDelegate,
                                   ASAuthorizationControllerPresentationContextProviding  {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return .init(frame: .init(x: 0, y: 0, width: 300, height: 300)) // FIXME: ??
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let _ = appleIDCredential.fullName
            let email = appleIDCredential.email
            Console.log("userIdentifier: \(userIdentifier), email: \(email ?? "")")
            listener?.successLogin()
            
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            Console.log("username: \(username), password: \(password)")
            listener?.successLogin()
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        // TODO: Handle Error
        Console.error(error.localizedDescription)
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
        
        [kakaoLoginButton, appleLoginButton].forEach {
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(91)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI
import AuthenticationServices

@available(iOS 13.0, *)
struct LoggedOutViewController_Preview: PreviewProvider {
    static var previews: some View {
        LoggedOutViewController().showPreview()
    }
}
#endif
