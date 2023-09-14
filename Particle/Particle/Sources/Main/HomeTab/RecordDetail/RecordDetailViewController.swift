//
//  RecordDetailViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/02.
//

import RIBs
import RxSwift
import UIKit

protocol RecordDetailPresentableListener: AnyObject {
    func recordDetailCloseButtonTapped()
    func recordDetailDeleteButtonTapped(with id: String) -> Observable<Bool>
}

final class RecordDetailViewController: UIViewController,
                                        RecordDetailPresentable,
                                        RecordDetailViewControllable {
    
    weak var listener: RecordDetailPresentableListener?
    private var disposeBag = DisposeBag()
    private let data: RecordReadDTO
    
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
        button.imageView?.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        button.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
        return button
    }()
    
    private let ellipsisButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.ellipsis, for: .normal)
        button.imageView?.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        button.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
        return button
    }()
    
    private let recordTitle: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_title01, color: .white, text: "효과적인 포스트모텔 회의를 진행하는 방법")
        label.numberOfLines = 0
        return label
    }()
    
    private let sentenceStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let recommendTagCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        
        let collectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LeftAlignedCollectionViewCell2.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.text = "https://stackoverflow.com/questions/67082716/swiftui-tabbar-ellipsis-not-vertically-centered"
        label.numberOfLines = 0
        label.textColor = .particleColor.gray03
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 11)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2023.05.23"
        label.numberOfLines = 0
        label.textColor = .particleColor.gray03
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        label.snp.makeConstraints{
            $0.height.equalTo(21)
        }
        return label
    }()
    
    private let directorLabel: UILabel = {
        let label = UILabel()
        label.text = "particle by _ 꾸꾸"
        label.numberOfLines = 0
        label.textColor = .particleColor.gray03
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        label.snp.makeConstraints{
            $0.height.equalTo(21)
        }
        return label
    }()
    
    private let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.heart, for: .normal)
        button.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        return button
    }()
    
    private lazy var warningAlert: ParticleAlert = {
        let deleteButton = UIButton()
        deleteButton.setAttributedTitle(NSMutableAttributedString().attributeString(string: "삭제", font: .particleFont.generate(style: .pretendard_SemiBold, size: 17), textColor: .init(hex: 0xFF453A)), for: .normal)
        deleteButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        let cancelButton = UIButton()
        cancelButton.setAttributedTitle(NSMutableAttributedString().attributeString(string: "취소", font: .particleFont.generate(style: .pretendard_Regular, size: 17), textColor: .init(hex: 0xC5C5C5)), for: .normal)
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        let alert = ParticleAlert(title: "파티클 삭제", body: "내 파티클을 정말 삭제하시겠어요?", buttons: [deleteButton, cancelButton], buttonsAxis: .vertical)
        alert.alpha = 0
        
        cancelButton.rx.tap.bind { [weak self] _ in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                alert.alpha = 0
            }
        }
        .disposed(by: self.disposeBag)
        
        
        deleteButton.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                alert.alpha = 0
            }
            
            // TODO: 삭제 로딩중
            
            self.listener?.recordDetailDeleteButtonTapped(with: self.data.id).subscribe { [weak self] bool in
                if bool == true {
                    self?.listener?.recordDetailCloseButtonTapped()
                } else {
                    // TODO: 삭제실패얼럿
                }
            }
            .disposed(by: self.disposeBag)
        }
        .disposed(by: self.disposeBag)
        
        return alert
    }()
    
    // MARK: - Initializers
    
    init(data: RecordReadDTO) {
        self.data = data
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
        setSentences()
        configureButton()
        bind()
    }
    
    // MARK: - Methods
    
    private func setSentences() {
        setRecordTitle(data.title)
        urlLabel.text = data.url
        dateLabel.text = DateManager.shared.convert(previousDate: data.createdAt, to: "yyyy.MM.dd E요일")
        directorLabel.text = "particle by _ \(data.createdBy)"
        data.items
            .enumerated()
            .forEach { (i, text) in
                let label = UILabel()
                label.setParticleFont(
                    text.isMain ? .y_headline : .p_body02,
                    color: text.isMain ? .particleColor.gray05 : .particleColor.gray04,
                    text: text.content
                )
                label.numberOfLines = 0
                sentenceStack.addArrangedSubview(label)
            }
    }
    
    private func setRecordTitle(_ text: String) {
        recordTitle.setParticleFont(.y_title01, color: .white, text: text)
    }
    
    private func bind() {
        Observable.of(data.tags)
            .bind(to: recommendTagCollectionView.rx.items(
                cellIdentifier: LeftAlignedCollectionViewCell2.defaultReuseIdentifier,
                cellType: LeftAlignedCollectionViewCell2.self)
            ) { index, item, cell in
                cell.titleLabel.text = item
            }
            .disposed(by: disposeBag)
    }
    
    private func configureButton() {
        closeButton.rx.tap.bind { [weak self] _ in
            self?.listener?.recordDetailCloseButtonTapped()
        }
        .disposed(by: disposeBag)
        
        ellipsisButton.rx.tap.bind { [weak self] _ in
            // TODO: Activity Controller
            DispatchQueue.main.async {
                self?.showActionSheetInMyRecord()
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func showActionSheetInMyRecord() {
        let shareAction = UIAlertAction(title: "공유하기", style: .default, handler: { action in
            //
        })
        
        let modifyAction = UIAlertAction(title: "수정하기", style: .default, handler: { action in
            //
        })
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] action in

            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [weak self] in
                self?.warningAlert.alpha = 1
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: { action in
            //
        })
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(modifyAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - Layout Settting

private extension RecordDetailViewController {
    func addSubviews() {
        [closeButton, ellipsisButton]
            .forEach {
                navigationBar.addSubview($0)
            }
        
        [
            navigationBar,
            recordTitle,
            sentenceStack,
            recommendTagCollectionView,
            urlLabel,
            dateLabel,
            directorLabel,
            heartButton,
            warningAlert
        ]
            .forEach {
                self.view.addSubview($0)
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
        
        ellipsisButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(Metric.NavigationBar.nextButtonRightMargin)
        }
        
        recordTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(navigationBar.snp.bottom).offset(12)
        }
        
        sentenceStack.snp.makeConstraints {
            $0.top.equalTo(recordTitle.snp.bottom).offset(33)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.greaterThanOrEqualTo(50)
        }
        
        recommendTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(sentenceStack.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        urlLabel.snp.makeConstraints {
            $0.top.equalTo(recommendTagCollectionView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(urlLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        directorLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        heartButton.snp.makeConstraints {
            $0.top.equalTo(directorLabel.snp.bottom).offset(27)
            $0.leading.equalToSuperview().inset(20)
        }
        
        warningAlert.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct RecordDetailViewController_Preview: PreviewProvider {
    static let data = RecordReadDTO(
        id: "",
        title: "제목 테스트",
        url: "www.testulr.com",
        items: [
            .init(content: "그렇게 쓴 글은 매일 사회관계망서비스(SNS)에 남기기도 하고, 모아서 책으로 내기도 한다.", isMain: false),
            .init(content: "개인적으로 나는 매일 글쓰는 일을 습관처럼 하고 있다.", isMain: true),
            .init(content: "그러나 처음부터 글을 습관처럼 매일 쓸 수 있었던 건 아니다.", isMain: false),
            .init(content: "하지만 당시에는 작가가 되고 싶다는 열망 하나를 갖고 있었고, 그 젊은 열망에 따라 어떻게", isMain: false)
        ],
        tags: ["#UXUI", "#브랜딩"],
        createdAt: "11",
        createdBy: "노란 동그라미"
    )
    
    static var previews: some View {
        RecordDetailViewController(data: data).showPreview()
    }
}
#endif

