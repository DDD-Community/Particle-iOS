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
import AuthenticationServices

import UIKit

protocol LoggedOutPresentableListener: AnyObject {
    func successLogin(with provider: String, identifier: String)
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable{
    
    weak var listener: LoggedOutPresentableListener?
    
    private enum Metric {
        static let backgroundImageTopInset: CGFloat = 136
        static let backgroundImageBottomInset: CGFloat = 186
        
        enum TitleStack {
            static let spacing: CGFloat = 14
            static let topInset: CGFloat = 56
            static let horizontalInset: CGFloat = 20
        }
        
        enum ButtonStack {
            static let spacing: CGFloat = 16
            static let horizontalInset: CGFloat = 20
            static let bottomInset: CGFloat = 91
        }
    }
    
    // MARK: - UIComponents
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.TitleStack.spacing
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
        stackView.spacing = Metric.ButtonStack.spacing
        return stackView
    }()
    
    private let kakaoLoginButton = ParticleLoginButton(
        backgroundColor: .init(hex: 0xFEE500),
        iconImage: .particleImage.kakaoLogo,
        title: "카카오 로그인",
        titleColor: .init(hex: 0x191919)
    )

    private let appleLoginButton = ParticleLoginButton(
        backgroundColor: .init(hex: 0x000000),
        iconImage: .particleImage.appleLogo,
        title: "Apple 로그인",
        titleColor: .init(hex:0xFFFFFF)
    )
    
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
            loginWithKakaoTalkApp()
        } else {
            Console.error("카카오톡이 설치되어있지 않습니다.")
            loginWithKakaoAccount()
        }
    }
    
    private func loginWithKakaoTalkApp() {
        
        UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
            if let error = error {
                Console.error(error.localizedDescription)
            } else {
                Console.log("\(#function) success")
                
                UserApi.shared.me { (user, error) in
                    guard let identifier = user?.id else {
                        Console.error("kakaoLogin user.id 가 존재하지 않습니다.")
                        return
                    }
                    self?.listener?.successLogin(with: "kakao", identifier: "\(identifier)")
                }
            }
        }
    }
    
    private func loginWithKakaoAccount() {

        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            if let error = error {
                Console.error(error.localizedDescription)
            } else {
                Console.log("\(#function) success.")

                UserApi.shared.me { (user, error) in /// weak self?
                    guard let identifier = user?.id else {
                        Console.error("kakaoLogin user.id 가 존재하지 않습니다.")
                        return
                    }
                    self?.listener?.successLogin(with: "kakao", identifier: "\(identifier)")
                }
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
            let _ = appleIDCredential.email
            Console.log("\(#function) success")
            listener?.successLogin(with: "apple", identifier: "\(userIdentifier)")
            
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let _ = passwordCredential.password
            Console.log("\(#function) success")
            listener?.successLogin(with: "apple", identifier: "\(username)")
            
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
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(Metric.backgroundImageTopInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Metric.backgroundImageBottomInset)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(Metric.TitleStack.topInset)
            $0.horizontalEdges.equalToSuperview().inset(Metric.TitleStack.horizontalInset)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(Metric.ButtonStack.horizontalInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Metric.ButtonStack.bottomInset)
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
