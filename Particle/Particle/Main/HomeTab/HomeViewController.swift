//
//  HomeViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift
import UIKit

protocol HomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func showPHPickerViewController()
    func dismiss()
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {

    weak var listener: HomePresentableListener?
    
    private let plusButton: UIView = {
        let plusIcon: UIImageView = {
            let imageView = UIImageView()
            imageView.image = .particleImage.plusButton
            return imageView
        }()
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 30
        blurView.layer.borderColor = UIColor(hex: 0xFFFFFF, alpha: 0.1).cgColor
        blurView.layer.borderWidth = 1
        blurView.clipsToBounds = true
        blurView.contentView.addSubview(plusIcon)
        plusIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return blurView
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "홈"
        tabBarItem.image = .particleImage.homeTabIcon?.withTintColor(.init(hex: 0x696969))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        configurePlusButton()
    }
    
    private func setupInitialView() {
        view.backgroundColor = .init(hex: 0x1f1f1f)
//        let navigationBarAppearance = UINavigationBarAppearance()
//        navigationBarAppearance.backgroundColor = .init(hex: 0x1f1f1f)
//        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
//        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.isNavigationBarHidden = true
        
        let window = UIApplication.shared.windows.first
        let statusBarManager = window?.windowScene?.statusBarManager
        
        let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
        statusBarView.backgroundColor = .init(hex: 0x1f1f1f)
        window?.addSubview(statusBarView)
        
        addSubviews()
        setConstraints()
    }
    
    private func configurePlusButton() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(buttonTapped)
        )
        plusButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func buttonTapped() {
        print("버튼눌림! ")
        UIView.animate(withDuration: 0.1) { [self] in
            plusButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { [self] _ in
            UIView.animate(withDuration: 0.1) { [self] in
                plusButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            // TODO: - Route To AddArticle RIB !!
            listener?.showPHPickerViewController()
        }
    }
    
    
    func present(viewController: RIBs.ViewControllable) {
        present(viewController.uiviewController, animated: true, completion: nil)
    }
    
    func dismiss(viewController: RIBs.ViewControllable) {
        if presentedViewController === viewController.uiviewController {
            dismiss(animated: true)
        }
    }
}

// MARK: - Layout Settings
private extension HomeViewController {
    
    func addSubviews() {
        view.addSubview(plusButton)
    }
    
    func setConstraints() {
        
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-110)
        }
    }
}

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct HomeViewController_Preview: PreviewProvider {
    static var previews: some View {
        HomeViewController().showPreview()
    }
}
#endif
