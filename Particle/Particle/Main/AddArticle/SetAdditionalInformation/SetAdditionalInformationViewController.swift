//
//  SetAdditionalInformationViewController.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import RIBs
import RxSwift
import UIKit

protocol SetAdditionalInformationPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SetAdditionalInformationViewController: UIViewController, SetAdditionalInformationPresentable, SetAdditionalInformationViewControllable {

    weak var listener: SetAdditionalInformationPresentableListener?
    
    enum Metric {
        enum Title {
            static let topMargin = 12
            static let leftMargin = 20
        }
        
        enum NavigationBar {
            static let height = 44
            static let backButtonLeftMargin = 8
            static let nextButtonRightMargin = 8
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.text = "아티클의 링크와 제목을 입력하고\n태그로 정리해보세요"
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let navigationBar: UIView = {
        let view = UIView()
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.backButton, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
        self.view.backgroundColor = .black
        addSubviews()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func bind() {

    }
    
    // MARK: - Add Subviews
    private func addSubviews() {
        [backButton, nextButton]
            .forEach {
                navigationBar.addSubview($0)
            }
        
        [
            navigationBar,
            titleLabel
        ]
            .forEach {
                self.view.addSubview($0)
            }
    }
    
    // MARK: - Layout
    private func layout() {
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(Metric.NavigationBar.height)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(Metric.NavigationBar.nextButtonRightMargin)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(Metric.Title.topMargin)
            make.left.equalTo(self.view.safeAreaLayoutGuide).inset(Metric.Title.leftMargin)
        }
    }
}
