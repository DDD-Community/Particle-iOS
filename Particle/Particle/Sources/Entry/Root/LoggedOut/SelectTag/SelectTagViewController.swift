//
//  SelectTagViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/24.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import SnapKit

protocol SelectTagPresentableListener: AnyObject {
    func backButtonTapped()
    func startButtonTapped(with selectedTags: [String])
}

final class SelectTagViewController: UIViewController, SelectTagPresentable, SelectTagViewControllable {
    
    enum Metric {
        
        enum NavigationBar {
            static let height = 44
            static let backButtonLeftMargin = 8
            static let nextButtonRightMargin = 8
        }
    }

    weak var listener: SelectTagPresentableListener?
    private var disposeBag: DisposeBag = .init()
    
    private var selectedTags: BehaviorRelay<[[String]]> = .init(value: Array(repeating: [], count: 5))
    
    // MARK: - UIComponents
    
    private let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.black
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.backButton, for: .normal)
        return button
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
    
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.text = "관심 태그를 설정하고\n아티클을 저장해보세요" // TODO: lineHeight 지정
        label.numberOfLines = 2
        label.font = .particleFont.generate(style: .ydeStreetB, size: 19)
        label.textColor = .particleColor.gray04
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.text = "최대 5개까지 설정할 수 있어요."
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 12)
        label.textColor = .particleColor.main100
        return label
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
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.font = .particleFont.generate(style: .pretendard_SemiBold, size: 16)
        button.setTitleColor(.particleColor.gray03, for: .disabled)
        button.setTitleColor(.particleColor.gray01, for: .normal)
        button.backgroundColor = .particleColor.main30
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
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
        setupNavigationBar()
        configureButton()
        bind()
    }
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
    }
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        backButton.rx.tap
            .bind { [weak self] in
                self?.listener?.backButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureButton() {
        startButton.addTarget(
            self,
            action: #selector(startButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func startButtonTapped() {
        let tags = selectedTags.value.flatMap { $0 }
        listener?.startButtonTapped(with: tags.map { Tag(rawValue: $0)?.value ?? "UXUI" })
    }
    
    private func bind() {
        
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
                self?.startButton.isEnabled = false
                self?.startButton.backgroundColor = .particleColor.main30
            } else {
                self?.startButton.isEnabled = true
                self?.startButton.backgroundColor = .particleColor.main100
            }
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - Layout Settting

private extension SelectTagViewController {
    
    func addSubviews() {
        
        [backButton].forEach {
            navigationBar.addSubview($0)
        }
        
        [navigationBar, mainScrollView, startButton].forEach {
            view.addSubview($0)
        }
        [mainTitle, subTitle, mainStackView].forEach {
            mainScrollView.addSubview($0)
        }
        
        [accordion1, accordion2, accordion3, accordion4, accordion5].forEach {
            mainStackView.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        
        navigationBar.snp.makeConstraints {
            $0.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.NavigationBar.height)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        mainTitle.snp.makeConstraints {
            $0.top.equalTo(mainScrollView.snp.top).offset(12)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(8)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        mainScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(startButton.snp.top)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(subTitle.snp.bottom).offset(18)
            $0.leading.trailing.equalTo(mainScrollView)
            $0.bottom.equalTo(mainScrollView).inset(20)
            $0.width.equalTo(mainScrollView.frameLayoutGuide)
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
        
        startButton.snp.makeConstraints {
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SelectTagViewController_Preview: PreviewProvider {
    static var previews: some View {
        SelectTagViewController().showPreview()
    }
}
#endif
