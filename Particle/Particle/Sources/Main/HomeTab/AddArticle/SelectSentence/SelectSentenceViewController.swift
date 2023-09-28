//
//  SelectSentenceViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/13.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import VisionKit
import Vision
import Photos

protocol SelectSentencePresentableListener: AnyObject {
    
    func showEditSentenceModal(with text: String)
    func backButtonTapped()
    func nextButtonTapped()
}

final class SelectSentenceViewController: UIViewController,
                                          SelectSentencePresentable,
                                          SelectSentenceViewControllable {
    
    enum Metric {
        enum Title {
            static let topMargin = 12
            static let leftMargin = 20
        }
        
        enum NavigationBar {
            static let height: CGFloat = 44
            static let backButtonLeftMargin: CGFloat = 8
            static let nextButtonRightMargin: CGFloat = 8
        }
        
        enum InfoBox {
            static let height: CGFloat = 53
            static let infoLabelLeftInset: CGFloat = 20
        }
        
        enum CollectionViewCell {
            static let width = DeviceSize.width
            static let height = DeviceSize.height - Metric.NavigationBar.height - InfoBox.height - 100
        }
    }
    
    weak var listener: SelectSentencePresentableListener?
    private var disposeBag: DisposeBag = .init()
    
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
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.setTitleColor(.particleColor.main100, for: .normal)
        return button
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.text = "문장 선택 1/7"
        label.font = .systemFont(ofSize: 19)
        label.textColor = .white
        return label
    }()
    
    private let infoBox: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.bk02
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "시작 단어와 끝 단어를 터치해 주세요."
        label.textColor = .particleColor.gray03
        return label
    }()
    
    private let selectedPhotoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: Metric.CollectionViewCell.width,
            height: Metric.CollectionViewCell.height
        )
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SelectedPhotoCell.self)
        collectionView.backgroundColor = .init(hex: 0x1f1f1f)
        return collectionView
    }()
    
    private let selectedImages: [PHAsset]
    
    // MARK: - Initializers
    
    init(selectedImages: [PHAsset]) {
        self.selectedImages = selectedImages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let alreadyShow = UserDefaults.standard.object(forKey: "ShowSwipeGuide") as? Bool,
              alreadyShow == false else {
            return
        }
        showSwipeGuide()
    }
    
    private func setupInitialView() {
        view.backgroundColor = .black
        addSubviews()
        setConstraints()
        setupNavigationBar()
        bind()
    }
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        
        backButton.rx.tap
            .bind { [weak self] in
                self?.listener?.backButtonTapped()
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { [weak self] in
                self?.listener?.nextButtonTapped()
            }
            .disposed(by: disposeBag)
        
        // TODO: 각 사진에서 문장추출이 모두 완료되었을 때 nextButton 활성화
        nextButton.isEnabled = false
    }
    
    private func bind() {
        
        bindCollectionViewCell()
        bindPageIndex()
    }
    
    private func bindCollectionViewCell() {
        Observable.of(selectedImages)
            .bind(to: selectedPhotoCollectionView.rx.items(
                cellIdentifier: SelectedPhotoCell.defaultReuseIdentifier,
                cellType: SelectedPhotoCell.self)
            ) { [weak self] index, item, cell in
                cell.setImage(with: item)
                cell.listener = self
            }
            .disposed(by: disposeBag)
    }
    
    // FIXME: - 사진 선택 맥시멈갯수 지정
    private func bindPageIndex() {
        selectedPhotoCollectionView
            .rx
            .contentOffset
            .subscribe { [weak self] point in
                guard let self = self, let positionX = point.element?.x else { return }
                switch positionX {
                case (0..<DeviceSize.width/2):
                    self.navigationTitle.text = "문장 선택 1/\(self.selectedImages.count)"
                case (DeviceSize.width/2..<DeviceSize.width*(3/2)):
                    self.navigationTitle.text = "문장 선택 2/\(self.selectedImages.count)"
                case (DeviceSize.width*(3/2)..<DeviceSize.width*(5/2)):
                    self.navigationTitle.text = "문장 선택 3/\(self.selectedImages.count)"
                case (DeviceSize.width*(5/2)..<DeviceSize.width*(7/2)):
                    self.navigationTitle.text = "문장 선택 4/\(self.selectedImages.count)"
                case (DeviceSize.width*(7/2)..<DeviceSize.width*(9/2)):
                    self.navigationTitle.text = "문장 선택 5/\(self.selectedImages.count)"
                default:
                    return
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func showSwipeGuide() {
        
        UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseOut]) { [weak self] in
            self?.selectedPhotoCollectionView.contentOffset.x = 70
        } completion: { _ in
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut]) { [weak self] in
                self?.selectedPhotoCollectionView.contentOffset.x = 1
            }
        }
        UserDefaults.standard.set(true, forKey: "ShowSwipeGuide")
    }
    
    // MARK: - SelectSentenceViewControllable
    
    func present(viewController: ViewControllable) {
        present(viewController.uiviewController, animated: true)
    }
    
    func dismiss(viewController: ViewControllable) {
        if presentedViewController === viewController.uiviewController {
            dismiss(animated: true)
        }
    }
}

extension SelectSentenceViewController: SelectedPhotoCellListener {
    
    func copyButtonTapped(with text: String) {
        listener?.showEditSentenceModal(with: text)
    }
}

// MARK: - Layout Settting

private extension SelectSentenceViewController {
    
    func addSubviews() {
        [backButton, navigationTitle, nextButton].forEach {
            navigationBar.addSubview($0)
        }
        
        [navigationBar, infoBox, selectedPhotoCollectionView].forEach {
            view.addSubview($0)
        }
        
        infoBox.addSubview(infoLabel)
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
        
        nextButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(Metric.NavigationBar.nextButtonRightMargin)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        infoBox.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.InfoBox.height)
        }
        
        infoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Metric.InfoBox.infoLabelLeftInset)
        }
        
        selectedPhotoCollectionView.snp.makeConstraints {
            $0.top.equalTo(infoBox.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SelectSentenceViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        SelectSentenceViewController(selectedImages: []).showPreview()
    }
}
#endif
