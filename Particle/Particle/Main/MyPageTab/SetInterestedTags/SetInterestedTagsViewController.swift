//
//  SelectInterestedTagsViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/10.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import SnapKit

protocol SetInterestedTagsPresentableListener: AnyObject {
    func setInterestedTagsBackButtonTapped()
    func setInterestedTagsOKButtonTapped(with tags: [String])
}

final class SetInterestedTagsViewController: UIViewController,
                                             SetInterestedTagsPresentable,
                                             SetInterestedTagsViewControllable {
    
    weak var listener: SetInterestedTagsPresentableListener?
    private var disposeBag = DisposeBag()
    private var selectedTags: BehaviorRelay<[[String]]> = .init(value: Array(repeating: [], count: 5))
    
    enum Metric {
        enum NavigationBar {
            static let height = 44
            static let backButtonLeftMargin = 8
            static let okButtonRightMargin = 8
        }
    }
    
    // MARK: - UI Components
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        // Create an indicator.
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.color = .particleColor.main100
        
        return activityIndicator
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
    
    private let okButton: UIButton = {
        let button = UIButton()
        
        button.setAttributedTitle(
            NSMutableAttributedString()
                .attributeString(
                    string: "확인",
                    font: .particleFont.generate(style: .pretendard_SemiBold, size: 16),
                    textColor: .particleColor.main100
                ),
            for: .normal
        )
        
        return button
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_title02, color: .particleColor.white, text: "관심 태그 설정")
        return label
    }()
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    private let accordion1: Accordion = {
        let accordion = Accordion(title: "디자인", tags: ["#브랜딩", "#UXUI", "#그래픽 디자인", "#산업 디자인"])
        return accordion
    }()
    private let accordion2: Accordion = {
        let accordion = Accordion(title: "마케팅", tags: ["#브랜드 마케팅", "#그로스 마케팅", "#콘텐츠 마케팅"])
        return accordion
    }()
    private let accordion3: Accordion = {
        let accordion = Accordion(title: "기획", tags: ["#서비스 기획", "#전략 기획", "#시스템 기획", "#데이터 분석"])
        return accordion
    }()
    private let accordion4: Accordion = {
        let accordion = Accordion(title: "개발", tags: ["#iOS", "#Android", "#Web", "#서버", "#AI"])
        return accordion
    }()
    private let accordion5: Accordion = {
        let accordion = Accordion(title: "스타트업", tags: ["#조직 문화", "#트랜드", "#CX", "#리더쉽", "#인사이트"])
        return accordion
    }()
    
    private var accordion1HeightConstraint: Constraint?
    private var accordion2HeightConstraint: Constraint?
    private var accordion3HeightConstraint: Constraint?
    private var accordion4HeightConstraint: Constraint?
    private var accordion5HeightConstraint: Constraint?
    
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
        bindAccordion()
        configureButton()
    }
    
    // MARK: - Methods
    
    private func bindAccordion() {
        
        let accordions: [(view: Accordion, constraint: Constraint?)] = [
            (accordion1, accordion1HeightConstraint),
            (accordion2, accordion2HeightConstraint),
            (accordion3, accordion3HeightConstraint),
            (accordion4, accordion4HeightConstraint),
            (accordion5, accordion5HeightConstraint)
        ]
        
        accordions.enumerated().forEach { (i, accordion) in
            accordion.view.height.subscribe { dynamicHeight in
                guard let dynamicHeight = dynamicHeight.element, dynamicHeight > 50 else {
                    return
                }
                accordion.constraint?.update(offset: dynamicHeight)
            }
            .disposed(by: disposeBag)
            
            accordion.view.selectedTags.subscribe { [weak self] selectedTagsInAccordion in
                guard let self = self else { return }
                guard let selectedTagsInAccordion = selectedTagsInAccordion.element else { return }
                var list = self.selectedTags.value
                list[i] = selectedTagsInAccordion
                self.selectedTags.accept(list)
                Console.log("\(self.selectedTags)")
            }
            .disposed(by: disposeBag)
        }
        
        selectedTags.subscribe { [weak self] tags in
            let flattenList = tags.flatMap { $0 }
            if flattenList.isEmpty {
                self?.okButton.isEnabled = false
            } else {
                self?.okButton.isEnabled = true
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func configureButton() {
        backButton.rx.tap.bind { [weak self] _ in
            self?.listener?.setInterestedTagsBackButtonTapped()
        }
        .disposed(by: disposeBag)
        
        okButton.rx.tap.bind { [weak self] _ in
            self?.listener?.setInterestedTagsOKButtonTapped(with: self?.selectedTags.value.flatMap { $0 }.map { Tag.init(rawValue: $0)?.value ?? "UXUI" } ?? [])
            self?.activityIndicator.startAnimating()
        }
        .disposed(by: disposeBag)
    }
    
    func showUploadSuccessAlert() {
        activityIndicator.stopAnimating()
        Console.debug("업로드 성공 얼럿 띄우기 !")
        listener?.setInterestedTagsBackButtonTapped()
    }
}

// MARK: - Layout Setting

private extension SetInterestedTagsViewController {
    
    func addSubviews() {
        [
            backButton,
            navigationTitle,
            okButton
        ]
            .forEach {
                navigationBar.addSubview($0)
            }
        
        [
            navigationBar,
            mainScrollView,
            activityIndicator
        ]
            .forEach {
                view.addSubview($0)
            }
        
        [mainStackView].forEach {
            mainScrollView.addSubview($0)
        }
        
        [
            accordion1,
            accordion2,
            accordion3,
            accordion4,
            accordion5,
        ]
            .forEach {
                mainStackView.addArrangedSubview($0)
            }
    }
    
    func setConstraints() {
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.NavigationBar.height)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        okButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Metric.NavigationBar.okButtonRightMargin)
        }
        
        mainScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        mainStackView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(mainScrollView.frameLayoutGuide)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        accordion1.snp.makeConstraints {
            accordion1HeightConstraint = $0.height.equalTo(52).constraint
        }
        accordion2.snp.makeConstraints {
            accordion2HeightConstraint = $0.height.equalTo(52).constraint
        }
        accordion3.snp.makeConstraints {
            accordion3HeightConstraint = $0.height.equalTo(52).constraint
        }
        accordion4.snp.makeConstraints {
            accordion4HeightConstraint = $0.height.equalTo(52).constraint
        }
        accordion5.snp.makeConstraints {
            accordion5HeightConstraint = $0.height.equalTo(52).constraint
        }
    }
}


// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SetInterestedTagsViewController_Preview: PreviewProvider {
    static var previews: some View {
        SetInterestedTagsViewController().showPreview()
    }
}
#endif
