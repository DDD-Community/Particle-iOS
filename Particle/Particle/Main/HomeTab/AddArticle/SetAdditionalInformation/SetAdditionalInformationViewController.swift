//
//  SetAdditionalInformationViewController.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import RxCocoa

protocol SetAdditionalInformationPresentableListener: AnyObject {
    func setAdditionalInfoBackButtonTapped()
    func setAdditionalInfoNextButtonTapped(title: String, url: String, tags: [String])
}

final class SetAdditionalInformationViewController: UIViewController, SetAdditionalInformationPresentable, SetAdditionalInformationViewControllable {

    weak var listener: SetAdditionalInformationPresentableListener?
    private var disposeBag = DisposeBag()
    private var selectedTags2 = [String]()
    private var selectedTags: BehaviorRelay<[[String]]> = .init(value: Array(repeating: [], count: 5))
    private var tags: [(title: String, isSelected: Bool)] = [
        ("#UXUI", false),
        ("#브랜딩", false),
        ("#iOS", false),
        ("#그래픽 디자인", false)
    ]
    
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
        
        enum URLTextField {
            static let topMargin = 32
            static let horizontalMargin = 20
            static let underLineTopMargin = 5
        }
        
        enum TitleTextField {
            static let topMargin: CGFloat = 80
            static let horizontalMargin: CGFloat = 20
            static let underLineTopMargin = 5
        }
        
        enum RecommendTagTitle {
            static let topMargin: CGFloat = 54
            static let leftMargin: CGFloat = 20
        }
        
        enum Tags {
            static let topMagin: CGFloat = 12
            static let horizontalMargin: CGFloat = 20
            static let minimumLineSpacing: CGFloat = 10
            static let minimumInterItemSpacing: CGFloat = 10
        }
    }
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.text = "아티클의 링크와 제목을 입력하고\n태그로 정리해보세요"
        label.font = .particleFont.generate(style: .ydeStreetB, size: 19)
        label.numberOfLines = 0
        label.textColor = .particleColor.gray04
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
        button.setTitleColor(.particleColor.gray03, for: .disabled)
        button.setTitleColor(.particleColor.main100, for: .normal)
        button.snp.makeConstraints {
            $0.width.equalTo(52)
            $0.height.equalTo(44)
        }
        return button
    }()
    
    private let urlTextFieldSectionTitle: UILabel = {
        let label = UILabel()
        label.text = "url"
        label.textColor = .particleColor.gray03
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        label.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        return label
    }()
    
    private let urlTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSMutableAttributedString()
            .attributeString(
                string: "아티클의 url을 입력해 주세요",
                font: .particleFont.generate(style: .pretendard_Medium, size: 16),
                textColor: .particleColor.gray03
            )
        textField.font = .systemFont(ofSize: 14)
        textField.addLeftPadding(16)
        textField.textColor = .white
        textField.backgroundColor = .particleColor.gray01
        textField.layer.cornerRadius = 8
        textField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        return textField
    }()
    
    private let urlTextFieldWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "url을 입력해 주세요."
        label.textColor = .particleColor.warning
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 12)
        label.snp.makeConstraints {
            $0.height.equalTo(14.4)
        }
        return label
    }()
    
    private let titleTextFieldSectionTitle: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.textColor = .particleColor.gray03
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        label.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSMutableAttributedString()
            .attributeString(
                string: "제목을 입력해 주세요",
                font: .particleFont.generate(style: .pretendard_Medium, size: 16),
                textColor: .particleColor.gray03
            )
        textField.font = .systemFont(ofSize: 14)
        textField.addLeftPadding(16)
        textField.textColor = .white
        textField.backgroundColor = .particleColor.gray01
        textField.layer.cornerRadius = 8
        textField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        return textField
    }()
    
    private let titleTextFieldWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "제목을 입력해 주세요."
        label.textColor = .particleColor.warning
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 12)
        label.snp.makeConstraints {
            $0.height.equalTo(14.4)
        }
        return label
    }()
    
    private let recommendTagTitleLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_body01, color: .particleColor.gray04, text: "관심 태그")
        return label
    }()
    
    private let recommendTagCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.minimumLineSpacing = Metric.Tags.minimumLineSpacing
        layout.minimumInteritemSpacing = Metric.Tags.minimumInterItemSpacing
        
        let collectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LeftAlignedCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let allTagOpenButton: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_subhead, color: .particleColor.gray03, text: "전체 펼치기")
        return label
    }()
    
    private let allTagTitleLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_body01, color: .particleColor.gray04, text: "전체 태그")
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
        self.view.backgroundColor = .particleColor.black
        addSubviews()
        layout()
        bind()
        bindAccordion()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextFieldWarningLabel.isHidden = true
        titleTextFieldWarningLabel.isHidden = true
    }
    
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
            Console.debug("\(flattenList)")
        }
        .disposed(by: disposeBag)
    }
    
    private func bind() {
        Observable.of(tags)
        .bind(to: recommendTagCollectionView.rx.items(
            cellIdentifier: LeftAlignedCollectionViewCell.defaultReuseIdentifier,
            cellType: LeftAlignedCollectionViewCell.self)
        ) { index, item, cell in
            cell.titleLabel.text = item.title
        }
        .disposed(by: disposeBag)
        
        recommendTagCollectionView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self else { return }
            guard let index = indexPath.element else { return }
            guard let selectedCell = self.recommendTagCollectionView.cellForItem(at: index) as? LeftAlignedCollectionViewCell else {
                return
            }
            selectedCell.setSelected()
            // TODO: 현재 선택된 태그 저장
            self.tags[index.row].isSelected.toggle()
        }
        .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind { [weak self] in
                self?.listener?.setAdditionalInfoBackButtonTapped()
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { [weak self] in
                let isEmpty = self?.urlTextField.text?.isEmpty ?? true || self?.titleTextField.text?.isEmpty ?? true
                if isEmpty {
                    if self?.urlTextField.text?.isEmpty ?? true {
                        self?.urlTextField.layer.borderWidth = 1
                        self?.urlTextField.layer.borderColor = .particleColor.warning.cgColor
                        self?.urlTextFieldWarningLabel.isHidden = false
                    }
                    
                    if self?.titleTextField.text?.isEmpty ?? true {
                        self?.titleTextField.layer.borderWidth = 1
                        self?.titleTextField.layer.borderColor = .particleColor.warning.cgColor
                        self?.titleTextFieldWarningLabel.isHidden = false
                    }
                } else {
                    let selectedTags = self?.tags.filter { $0.isSelected == true }.map { Tag(rawValue: $0.title)?.value ?? "UXUI" } ?? []
                    
                    self?.listener?.setAdditionalInfoNextButtonTapped(
                        title: self?.titleTextField.text ?? "",
                        url: self?.urlTextField.text ?? "",
                        tags: selectedTags // TODO: 선택된 태그정보 전달
                    )
                }
            }
            .disposed(by: disposeBag)
        
        urlTextField.rx.text.subscribe { [weak self] inputText in
            if inputText.element != nil {
                self?.urlTextField.layer.borderWidth = 0
                self?.urlTextFieldWarningLabel.isHidden = true
            }
        }
        .disposed(by: disposeBag)
        
        titleTextField.rx.text.subscribe { [weak self] inputText in
            if inputText.element != nil {
                self?.titleTextField.layer.borderWidth = 0
                self?.titleTextFieldWarningLabel.isHidden = true
            }
        }
        .disposed(by: disposeBag)

    }
    
    // MARK: - Add Subviews
    private func addSubviews() {
        [backButton, nextButton]
            .forEach {
                navigationBar.addSubview($0)
            }
        
        [navigationBar, mainScrollView]
            .forEach {
                view.addSubview($0)
            }
        
        [
//            navigationBar,
            titleLabel,
            urlTextFieldSectionTitle,
            urlTextField,
            urlTextFieldWarningLabel,
            titleTextFieldSectionTitle,
            titleTextField,
            titleTextFieldWarningLabel,
            recommendTagTitleLabel,
            recommendTagCollectionView,
            allTagOpenButton,
            allTagTitleLabel,
            mainStackView
        ]
            .forEach {
                mainScrollView.addSubview($0)
            }
        
        [accordion1, accordion2, accordion3, accordion4, accordion5].forEach {
            mainStackView.addArrangedSubview($0)
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
        
        mainScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.Title.topMargin)
            make.left.equalToSuperview().inset(Metric.Title.leftMargin)
        }
        
        urlTextFieldSectionTitle.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        urlTextField.snp.makeConstraints { make in
            make.top.equalTo(urlTextFieldSectionTitle.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(Metric.URLTextField.horizontalMargin)
        }
        
        urlTextFieldWarningLabel.snp.makeConstraints {
            $0.top.equalTo(urlTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        titleTextFieldSectionTitle.snp.makeConstraints {
            $0.top.equalTo(urlTextField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextFieldSectionTitle.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(Metric.URLTextField.horizontalMargin)
        }
        
        titleTextFieldWarningLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        recommendTagTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(Metric.RecommendTagTitle.topMargin)
            make.left.equalToSuperview().inset(Metric.RecommendTagTitle.leftMargin)
        }
        
        recommendTagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendTagTitleLabel.snp.bottom).offset(Metric.Tags.topMagin)
            make.left.right.equalToSuperview().inset(Metric.Tags.horizontalMargin)
        }
        
        allTagOpenButton.snp.makeConstraints {
            $0.top.equalTo(recommendTagCollectionView.snp.bottom).offset(37)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        allTagTitleLabel.snp.makeConstraints {
            $0.top.equalTo(recommendTagCollectionView.snp.bottom).offset(48)
            $0.leading.equalToSuperview().inset(20)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(allTagTitleLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
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
    }
}

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SetAdditionalInformationViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        SetAdditionalInformationViewController().showPreview()
    }
}
#endif
