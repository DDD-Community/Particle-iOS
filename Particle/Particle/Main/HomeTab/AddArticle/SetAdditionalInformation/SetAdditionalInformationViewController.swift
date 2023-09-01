//
//  SetAdditionalInformationViewController.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import RIBs
import RxSwift
import UIKit
import RxCocoa

protocol SetAdditionalInformationPresentableListener: AnyObject {
    func setAdditionalInfoBackButtonTapped()
}

final class SetAdditionalInformationViewController: UIViewController, SetAdditionalInformationPresentable, SetAdditionalInformationViewControllable {

    weak var listener: SetAdditionalInformationPresentableListener?
    private var disposeBag = DisposeBag()
    
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
            static let topMargin: CGFloat = 80
            static let leftMargin: CGFloat = 20
        }
        
        enum Tags {
            static let topMagin: CGFloat = 12
            static let horizontalMargin: CGFloat = 20
            static let minimumLineSpacing: CGFloat = 10
            static let minimumInterItemSpacing: CGFloat = 10
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
    
    private let urlTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSMutableAttributedString()
            .attributeString(
                string: "url",
                font: .systemFont(ofSize: 14),
                textColor: .init(red: 105, green: 105, blue: 105)
            )
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .white
        return textField
    }()
    
    private let urlTextFieldUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .init(red: 197, green: 197, blue: 197, alpha: 1)
        return view
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSMutableAttributedString()
            .attributeString(
                string: "제목",
                font: .systemFont(ofSize: 14),
                textColor: .init(red: 105, green: 105, blue: 105)
            )
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .white
        return textField
    }()
    
    private let titleTextFieldUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .init(red: 197, green: 197, blue: 197, alpha: 1)
        return view
    }()
    
    private let recommendTagTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "추천 태그"
        label.numberOfLines = 1
        label.textColor = .init(red: 105, green: 105, blue: 105, alpha: 1)
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
        self.view.backgroundColor = .particleColor.black
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
        Observable.of([
        "#UXUI", "#브랜딩", "#마케팅", "#자기계발",
        "#UXUI", "#브랜딩", "#마케팅", "#자기계발",
        "#UXUI", "#브랜딩"
        ])
        .bind(to: recommendTagCollectionView.rx.items(
            cellIdentifier: LeftAlignedCollectionViewCell.defaultReuseIdentifier,
            cellType: LeftAlignedCollectionViewCell.self)
        ) { index, item, cell in
            cell.titleLabel.text = item
        }
        .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind { [weak self] in
                self?.listener?.setAdditionalInfoBackButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Add Subviews
    private func addSubviews() {
        [backButton, nextButton]
            .forEach {
                navigationBar.addSubview($0)
            }
        
        [
            navigationBar,
            titleLabel,
            urlTextField,
            urlTextFieldUnderLine,
            titleTextField,
            titleTextFieldUnderLine,
            recommendTagTitleLabel,
            recommendTagCollectionView
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
        
        urlTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.URLTextField.topMargin)
            make.left.right.equalToSuperview().inset(Metric.URLTextField.horizontalMargin)
        }
        
        urlTextFieldUnderLine.snp.makeConstraints { make in
            make.top.equalTo(urlTextField.snp.bottom).offset(Metric.URLTextField.underLineTopMargin)
            make.left.right.equalTo(urlTextField)
            make.height.equalTo(1)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(urlTextFieldUnderLine.snp.bottom).offset(Metric.TitleTextField.topMargin)
            make.left.right.equalToSuperview().inset(Metric.URLTextField.horizontalMargin)
        }
        
        titleTextFieldUnderLine.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(Metric.TitleTextField.underLineTopMargin)
            make.left.right.equalTo(titleTextField)
            make.height.equalTo(1)
        }
        
        recommendTagTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextFieldUnderLine.snp.bottom).offset(Metric.RecommendTagTitle.topMargin)
            make.left.equalToSuperview().inset(Metric.RecommendTagTitle.leftMargin)
        }
        
        recommendTagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendTagTitleLabel.snp.bottom).offset(Metric.Tags.topMagin)
            make.left.right.equalToSuperview().inset(Metric.Tags.horizontalMargin)
        }
    }
}
