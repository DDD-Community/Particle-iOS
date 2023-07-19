//
//  EditSentenceViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift
import UIKit

protocol EditSentencePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func pushToNextVC()
}

final class EditSentenceViewController: UIViewController, EditSentencePresentable, EditSentenceViewControllable {

    weak var listener: EditSentencePresentableListener?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "선택한 문장"
        label.textColor = .init(hex: 0xF3F3F3)
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 37, right: 20)
        return stackView
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0x2E2E2E)
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return stackView
    }()
    
    private let selectedTextView: UITextView = {
        let textView = UITextView()
        textView.text = "디자인은 사실 숫자와는 거리가 먼 영역이다. 그래서 언뜻 생각했을 때 데이터 기반으로 디자인한다는 게 뭔지 잘 와닿지 않았다."
        textView.textColor = .init(hex: 0xF3F3F3)
        textView.font = .systemFont(ofSize: 14)
        textView.backgroundColor = .init(hex: 0x1F1F1F)
        return textView
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "refresh"), for: .normal)
        button.backgroundColor = .init(hex: 0x2E2E2E)
        button.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(particleColor: .main)
        button.layer.cornerRadius = 8
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
    }
    
    private func setupInitialView() {
        view.backgroundColor = .init(hex: 0x1F1F1F)
        addSubviews()
        setConstraints()
        configureButton()
    }
    
    private func configureButton() {
        refreshButton.addTarget(
            self,
            action: #selector(refreshButtonTapped),
            for: .touchUpInside
        )
        nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func refreshButtonTapped() {
        // TODO: 원래의 Text 상태로 되돌리기
    }
    
    @objc private func nextButtonTapped() {
        // TODO: OrganizingSentence RIB 로 Route
        listener?.pushToNextVC()
    }
}

// MARK: - Layout Settting

private extension EditSentenceViewController {
    
    func addSubviews() {
        [titleLabel, divider, mainStackView].forEach {
            view.addSubview($0)
        }
        
        [refreshButton, nextButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [selectedTextView, buttonStackView].forEach {
            mainStackView.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(13)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(19)
            $0.bottom.leading.trailing.equalTo(view)
        }
    }
}

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct EditSentenceViewController_Preview: PreviewProvider {
    static var previews: some View {
        EditSentenceViewController().showPreview()
    }
}
#endif

