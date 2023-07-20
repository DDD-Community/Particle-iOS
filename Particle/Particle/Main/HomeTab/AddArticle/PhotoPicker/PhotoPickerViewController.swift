//
//  PhotoPickerViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/19.
//

import RIBs
import RxSwift
import UIKit
import PhotosUI

protocol PhotoPickerPresentableListener: AnyObject {
    
    func cancelButtonTapped()
    func nextButtonTapped(with images: [NSItemProvider])
}

final class PhotoPickerViewController: UIViewController, PhotoPickerPresentable, PhotoPickerViewControllable {
    
    enum Metric {
        enum NavigationBar {
            static let height = 44
            static let backButtonLeftMargin = 20
            static let nextButtonRightMargin = 20
        }
    }
    
    weak var listener: PhotoPickerPresentableListener?
    private var disposeBag: DisposeBag = .init()
    private var selectedItems: [NSItemProvider] = []
    
    private let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0x1f1f1f)
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.xmarkButton, for: .normal)
        return button
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.text = "최근항목"
        label.font = .systemFont(ofSize: 19)
        label.textColor = .white
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
//    private let imagePickerVC: PHPickerViewController = {
//        var config = PHPickerConfiguration()
//        config.filter = .images
//        config.selectionLimit = 5
//        let phpicker = PHPickerViewController(configuration: config)
//        phpicker.overrideUserInterfaceStyle = .dark
//        phpicker.modalPresentationStyle = .formSheet
//        return phpicker
//    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        configureButton()
//        imagePickerVC.delegate = self
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.present(imagePickerVC, animated: true, completion: nil)
//    }
    
    override func viewWillLayoutSubviews() {
        setupStatusBar()
    }
    
    private func setupInitialView() {
        view.backgroundColor = .init(hex: 0x1f1f1f)
        navigationController?.isNavigationBarHidden = true
        addSubviews()
        setConstraints()
    }
    
    private func setupStatusBar() {
        let window = UIApplication.shared.windows.first
        let statusBarManager = window?.windowScene?.statusBarManager
        
        let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
        statusBarView.backgroundColor = .init(hex: 0x1f1f1f)
        window?.addSubview(statusBarView)
    }
    
    private func configureButton() {
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.listener?.cancelButtonTapped()
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { [weak self] in
                self?.listener?.nextButtonTapped(with: self?.selectedItems ?? [])
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - PHPickerViewControllerDelegate
//extension PhotoPickerViewController: PHPickerViewControllerDelegate {

//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//
//        if results.count == 0 {
//
//            self.dismiss(animated: true)
//        } else {
//
//            let providers = results.filter {
//                $0.itemProvider.canLoadObject(ofClass: UIImage.self)
//            }.map {
//                $0.itemProvider
//            }
//            selectedItems = providers
//            self.dismiss(animated: true)
//        }
//    }
//}

// MARK: - Layout Settting

private extension PhotoPickerViewController {
    func addSubviews() {
        [navigationBar].forEach {
            view.addSubview($0)
        }
        
        [cancelButton, navigationTitle, nextButton].forEach {
            navigationBar.addSubview($0)
        }
    }
    
    func setConstraints() {
        
        navigationBar.snp.makeConstraints {
            $0.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.NavigationBar.height)
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(Metric.NavigationBar.nextButtonRightMargin)
        }
        
//        imagePickerVC.view.snp.makeConstraints {
//            $0.top.equalTo(navigationBar.snp.bottom)
//            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
//        }
    }
}

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct PhotoPickerViewController_Preview: PreviewProvider {
    static var previews: some View {
        PhotoPickerViewController().showPreview()
    }
}
#endif

