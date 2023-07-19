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
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func cancelButtonTapped()
    func nextButtonTapped(with images: [NSItemProvider])
}

final class PhotoPickerViewController: UIViewController, PhotoPickerPresentable, PhotoPickerViewControllable {
    
    weak var listener: PhotoPickerPresentableListener?
    
    private let imagePickerVC: PHPickerViewController = {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5
        let phpicker = PHPickerViewController(configuration: config)
        phpicker.overrideUserInterfaceStyle = .dark
        return phpicker
    }()
    
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
        imagePickerVC.delegate = self
    }
    
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
    
    func pushViewController(to viewController: ViewControllable) {
        //
    }
}

// MARK: - PHPickerViewControllerDelegate
extension PhotoPickerViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if results.count == 0 {
            
            listener?.cancelButtonTapped()
            
        } else {
            
            let providers = results.filter {
                $0.itemProvider.canLoadObject(ofClass: UIImage.self)
            }.map {
                $0.itemProvider
            }
            listener?.nextButtonTapped(with: providers)
        }
    }
}

// MARK: - Layout Settting

private extension PhotoPickerViewController {
    func addSubviews() {
        view.addSubview(imagePickerVC.view)
    }
    
    func setConstraints() {
        imagePickerVC.view.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
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

