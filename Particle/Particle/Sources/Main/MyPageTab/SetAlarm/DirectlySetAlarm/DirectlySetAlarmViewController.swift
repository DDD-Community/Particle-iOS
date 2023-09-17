//
//  DirectlySetAlarmViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs
import RxSwift
import UIKit

protocol DirectlySetAlarmPresentableListener: AnyObject {
    func directlySetAlarmCloseButtonTapped()
}

final class DirectlySetAlarmViewController: UIViewController,
                                            DirectlySetAlarmPresentable,
                                            DirectlySetAlarmViewControllable {

    weak var listener: DirectlySetAlarmPresentableListener?
    private var disposeBag = DisposeBag()
    
    enum Metric {
        enum NavigationBar {
            static let height = 44
            static let backButtonLeftMargin = 8
            static let nextButtonRightMargin = 8
        }
    }
    
    // MARK: - UI Components
    
    private let navigationBar: UIView = {
        let view = UIView()
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.xmarkButton, for: .normal)
        return button
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_title02, color: .particleColor.white, text: "알림설정")
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .time
        view.preferredDatePickerStyle = .wheels
        view.locale = Locale(identifier: "ko")
        view.textColor = .particleColor.white
        return view
    }()
    
    private let alarmNameSectionTitle: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_body02, color: .particleColor.gray03, text: "알림 이름")
        return label
    }()
    
    private let alarmNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .particleColor.gray01
        textField.addLeftPadding(16)
        textField.attributedPlaceholder = NSMutableAttributedString()
            .attributeString(
                string: "알림 이름 입력",
                font: .particleFont.generate(style: .pretendard_Regular, size: 16),
                textColor: .particleColor.gray03
            )
        textField.font = .particleFont.generate(style: .pretendard_Regular, size: 16)
        textField.textColor = .particleColor.white
        return textField
    }()
    
    private let alarmActivateSectionTitle: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_body02, color: .particleColor.gray03, text: "알림 활성화")
        return label
    }()
    
    private let alarmActivateButton: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.gray01
        view.layer.cornerRadius = 8
        view.layer.borderColor = .particleColor.main100.cgColor
        return view
    }()
    
    private let alarmActivateButtonLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_body01, color: .particleColor.gray03, text: "활성화")
        return label
    }()
    
    private let alarmActivateButtonIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = .particleImage.check
        return icon
    }()
    
    private let alarmDeactivateButton: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.gray01
        view.layer.cornerRadius = 8
        view.layer.borderColor = .particleColor.main100.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let alarmDeactivateButtonLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_body01, color: .particleColor.white, text: "비활성화")
        return label
    }()
    
    private let alarmDeactivateButtonIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = .particleImage.check
        return icon
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .particleColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setConstraints()
        configureButton()
        setInitialState()
    }
    
    // MARK: - Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func setInitialState() {
        alarmActivateButtonIcon.isHidden = true
    }
    
    private func configureButton() {
        closeButton.rx.tap.bind { [weak self] _ in
            self?.listener?.directlySetAlarmCloseButtonTapped()
        }
        .disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(alarmActivateButtonTapped))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(alarmDeactivateButtonTapped))
        
        alarmActivateButton.addGestureRecognizer(tapGesture)
        alarmDeactivateButton.addGestureRecognizer(tapGesture2)
    }
    
    @objc private func alarmActivateButtonTapped(){
        alarmDeactivateButton.layer.borderWidth = 0
        alarmDeactivateButtonIcon.isHidden = true
        alarmDeactivateButtonLabel.textColor = .particleColor.gray03
        
        alarmActivateButton.layer.borderWidth = 1
        alarmActivateButtonIcon.isHidden = false
        alarmActivateButtonLabel.textColor = .particleColor.white
    }
    @objc private func alarmDeactivateButtonTapped(){
        alarmDeactivateButton.layer.borderWidth = 1
        alarmDeactivateButtonIcon.isHidden = false
        alarmDeactivateButtonLabel.textColor = .particleColor.white
        
        alarmActivateButton.layer.borderWidth = 0
        alarmActivateButtonIcon.isHidden = true
        alarmActivateButtonLabel.textColor = .particleColor.gray03
    }
}

// MARK: - Layout Settting

private extension DirectlySetAlarmViewController {
    func addSubviews() {
        [closeButton, navigationTitle].forEach {
            navigationBar.addSubview($0)
        }
        
        [
            navigationBar,
            datePicker,
            alarmNameSectionTitle,
            alarmNameTextField,
            alarmActivateSectionTitle,
            alarmActivateButton,
            alarmDeactivateButton
        ]
            .forEach {
                view.addSubview($0)
            }
        
        [alarmActivateButtonLabel, alarmActivateButtonIcon].forEach {
            alarmActivateButton.addSubview($0)
        }
        
        [alarmDeactivateButtonLabel, alarmDeactivateButtonIcon].forEach {
            alarmDeactivateButton.addSubview($0)
        }
    }
    
    func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(Metric.NavigationBar.height)
        }
        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        datePicker.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        alarmNameSectionTitle.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(22)
            $0.leading.equalToSuperview().inset(20)
        }
        alarmNameTextField.snp.makeConstraints {
            $0.top.equalTo(alarmNameSectionTitle.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        alarmActivateSectionTitle.snp.makeConstraints {
            $0.top.equalTo(alarmNameTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        alarmActivateButton.snp.makeConstraints {
            $0.top.equalTo(alarmActivateSectionTitle.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo((DeviceSize.width-48)/2)
            $0.height.equalTo(44)
        }
        alarmDeactivateButton.snp.makeConstraints {
            $0.top.equalTo(alarmActivateSectionTitle.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo((DeviceSize.width-48)/2)
            $0.height.equalTo(44)
        }
        alarmActivateButtonIcon.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        alarmDeactivateButtonIcon.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        alarmActivateButtonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        alarmDeactivateButtonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct DirectlySetAlarmViewController_Preview: PreviewProvider {
    static var previews: some View {
        DirectlySetAlarmViewController().showPreview()
    }
}
#endif
extension UIDatePicker {

var textColor: UIColor? {
    set {
        setValue(newValue, forKeyPath: "textColor")
    }
    get {
        return value(forKeyPath: "textColor") as? UIColor
    }
  }
}
