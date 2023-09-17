//
//  MyRecordListViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/03.
//

import RIBs
import RxSwift
import SnapKit
import UIKit

protocol MyRecordListPresentableListener: AnyObject {

}

final class MyRecordListViewController: UIViewController,
                                        MyRecordListPresentable,
                                        MyRecordListViewControllable {

    weak var listener: MyRecordListPresentableListener?
    private var disposeBag = DisposeBag()
    
    enum Metric {
        enum NavigationBar {
            static let height = 45
            static let backButtonLeftMargin = 8
            static let backButtonIconSize = 20
            static let backButtonTapSize = 44
        }
    }
    
    private let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.black
        return view
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_title02, color: .white, text: "내가 저장한 아티클")
        label.numberOfLines = 0
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.backButton2, for: .normal)
        button.imageView?.snp.makeConstraints {
            $0.width.height.equalTo(Metric.NavigationBar.backButtonIconSize)
        }
        button.snp.makeConstraints {
            $0.width.height.equalTo(Metric.NavigationBar.backButtonTapSize)
        }
        return button
    }()
    
    private let recentlyOrderButtonLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_caption, color: .particleColor.gray04, text: "최신순")
        label.snp.makeConstraints {
            $0.width.equalTo((DeviceSize.width-40-14)/2)
            $0.height.equalTo(25)
        }
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let oldlyOrderButtonLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_caption, color: .particleColor.gray03, text: "오래된 순")
        label.snp.makeConstraints {
            $0.width.equalTo((DeviceSize.width-40-14)/2)
            $0.height.equalTo(25)
        }
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let segmentBar: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.bk02
        view.layer.cornerRadius = 12
        view.snp.makeConstraints {
            $0.width.equalTo((DeviceSize.width-40-14)/2)
            $0.height.equalTo(25)
        }
        return view
    }()
    
    private let segmentControl: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 17
        view.snp.makeConstraints {
            $0.height.equalTo(35)
        }
        return view
    }()
    
    private var segmentBarLeft: Constraint?
    private var segmentBarRight: Constraint?
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .particleColor.bk02
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setConstraints()
        configureSegmentControl()
    }
    
    // MARK: - Methods
    
    private func bind() {
        
    }
    
    private func configureSegmentControl() {
        let tabGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(recentlyOrderButtonTapped)
        )
        recentlyOrderButtonLabel.addGestureRecognizer(tabGesture)
        
        let tabGesture2 = UITapGestureRecognizer(
            target: self,
            action: #selector(oldlyOrderButtonTapped)
        )
        oldlyOrderButtonLabel.addGestureRecognizer(tabGesture2)
    }
    
    @objc private func recentlyOrderButtonTapped() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else { return }
            self.recentlyOrderButtonLabel.textColor = .particleColor.gray04
            self.oldlyOrderButtonLabel.textColor = .particleColor.gray03
            self.segmentBarLeft?.update(offset: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func oldlyOrderButtonTapped() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else { return }
            self.recentlyOrderButtonLabel.textColor = .particleColor.gray03
            self.oldlyOrderButtonLabel.textColor = .particleColor.gray04
            self.segmentBarLeft?.update(offset: ((DeviceSize.width-40-14) / 2) + 4)
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Layout Settting

private extension MyRecordListViewController {
    
    func addSubviews() {
        [navigationBar, segmentControl].forEach {
            view.addSubview($0)
        }
        
        [backButton, navigationTitle].forEach {
            navigationBar.addSubview($0)
        }
        
        [segmentBar, recentlyOrderButtonLabel, oldlyOrderButtonLabel].forEach {
            segmentControl.addSubview($0)
        }
    }
    
    func setConstraints() {
        
        navigationBar.snp.makeConstraints {
            $0.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.NavigationBar.height)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        segmentBar.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            segmentBarLeft = $0.leading.equalTo(recentlyOrderButtonLabel.snp.leading).constraint
        }
        
        recentlyOrderButtonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(5)
        }
        
        oldlyOrderButtonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MyRecordListViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        MyRecordListViewController().showPreview()
    }
}
#endif
