//
//  HomeViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift
import RxRelay
import UIKit

protocol HomePresentableListener: AnyObject {
    func cellTapped(with model: RecordReadDTO)
    func showPHPickerViewController()
    func dismiss()
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {
    
    weak var listener: HomePresentableListener?
    private var disposeBag = DisposeBag()
    
    private var recordList: BehaviorRelay<[RecordReadDTO]> = .init(value: [])
    
    // MARK: - UIComponents
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let myArticleSectionTitle: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.black
        
        let title = UILabel()
        title.setParticleFont(.y_title01, color: .particleColor.white, text: "나의 아티클")
        
        let infoButton = UIImageView()
        infoButton.image = .particleImage.info
        
        [title, infoButton].forEach {
            view.addSubview($0)
        }
        
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        infoButton.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(title.snp.trailing).offset(8)
        }
        
        return view
    }()
    
    private let myArticleSectionArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.arrowRight, for: .normal)
        return button
    }()
    
    private let horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: DeviceSize.width-40, height: 400)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 40
        layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecordCell.self)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .particleColor.black
        return collectionView
    }()
    
    private let plusButton: UIView = {
        let plusIcon: UIImageView = {
            let imageView = UIImageView()
            imageView.image = .particleImage.plusButton
            return imageView
        }()
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 30
        blurView.layer.borderColor = UIColor(hex: 0xFFFFFF, alpha: 0.1).cgColor
        blurView.layer.borderWidth = 1
        blurView.clipsToBounds = true
        blurView.contentView.addSubview(plusIcon)
        plusIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return blurView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_body01, color: .particleColor.main100, text: "앗! 아직 저장한 아티클이 없어요")
        return label
    }()
    
    private let emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .particleImage.eyes
        return imageView
    }()
    
    private let toolTip: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .particleImage.tooltip1
        return imageView
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "홈"
        tabBarItem.image = .particleImage.homeTabIcon?.withTintColor(.particleColor.gray03)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        configurePlusButton()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.1) { [self] in
            toolTip.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { [self] _ in
            UIView.animate(withDuration: 0.3) { [self] in
                toolTip.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }
    
    // MARK: - Methods
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
        navigationController?.isNavigationBarHidden = true
        
        let window = UIApplication.shared.windows.first
        let statusBarManager = window?.windowScene?.statusBarManager
        
        let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
        statusBarView.backgroundColor = .particleColor.black
        window?.addSubview(statusBarView)
        
        emptyLabel.isHidden = true
        emptyImage.isHidden = true
        mainScrollView.isHidden = true
        
        addSubviews()
        setConstraints()
    }
    
    private func bind() {

        recordList.bind(to: horizontalCollectionView.rx.items(
            cellIdentifier: RecordCell.defaultReuseIdentifier,
            cellType: RecordCell.self)) { index, dto, cell in
                cell.setupData(data: dto.toDomain())
            }
            .disposed(by: disposeBag)
        
        recordList.subscribe { [weak self] element in
            if element.isEmpty {
                self?.emptyLabel.isHidden = false
                self?.emptyImage.isHidden = false
                self?.mainScrollView.isHidden = true
            } else {
                self?.emptyLabel.isHidden = true
                self?.emptyImage.isHidden = true
                self?.mainScrollView.isHidden = false
            }
        }
        .disposed(by: disposeBag)
        
        horizontalCollectionView.rx.itemSelected.bind { [weak self] indexPath in
            guard let self = self else { return }
            self.listener?.cellTapped(with: self.recordList.value[indexPath.row])
            // TODO: RecordDetail RIB로 이동.
        }
        .disposed(by: disposeBag)
        
        myArticleSectionArrowButton.rx.tap.bind {
            Console.log("myArticleButtonTapped")
        }
        .disposed(by: disposeBag)
        
    }
    
    private func configurePlusButton() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(buttonTapped)
        )
        plusButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func buttonTapped() {
        UIView.animate(withDuration: 0.1) { [self] in
            plusButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { [self] _ in
            UIView.animate(withDuration: 0.1) { [self] in
                plusButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            listener?.showPHPickerViewController()
            toolTip.isHidden = true
        }
    }
    
    func setData(data: [RecordReadDTO]) {
        recordList.accept(data)
    }
    
    func present(viewController: RIBs.ViewControllable) {
        present(viewController.uiviewController, animated: true, completion: nil)
    }
    
    func dismiss(viewController: RIBs.ViewControllable) {
        if presentedViewController === viewController.uiviewController {
            dismiss(animated: true)
        }
    }
}

// MARK: - Layout Settings
private extension HomeViewController {
    
    func addSubviews() {
        [
            mainScrollView,
            plusButton,
            toolTip,
            emptyLabel,
            emptyImage
        ]
            .forEach {
                view.addSubview($0)
            }
        
        [
            myArticleSectionTitle,
            horizontalCollectionView,
        ]
            .forEach {
                mainScrollView.addSubview($0)
            }
        myArticleSectionTitle.addSubview(myArticleSectionArrowButton)
    }
    
    func setConstraints() {
        
        mainScrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview().inset(90)
            $0.width.equalToSuperview()
        }
        
        myArticleSectionTitle.snp.makeConstraints {
            $0.top.equalTo(mainScrollView.snp.top)
            $0.leading.trailing.equalTo(mainScrollView.frameLayoutGuide)
            $0.height.equalTo(55)
        }
        myArticleSectionArrowButton.imageView?.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        myArticleSectionArrowButton.snp.makeConstraints{
            $0.width.height.equalTo(44)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
        
        horizontalCollectionView.snp.makeConstraints {
            $0.top.equalTo(myArticleSectionTitle.snp.bottom)
            $0.leading.trailing.equalTo(mainScrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(400)
        }
        
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.bottom.equalToSuperview().offset(-110)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(331)
            $0.centerX.equalToSuperview()
        }
        
        emptyImage.snp.makeConstraints {
            $0.top.equalTo(emptyLabel.snp.bottom).offset(35)
            $0.width.equalTo(88)
            $0.height.equalTo(60)
            $0.centerX.equalToSuperview()
        }
        
        toolTip.snp.makeConstraints {
            $0.width.equalTo(226)
            $0.height.equalTo(37)
            $0.centerY.equalTo(plusButton.snp.centerY)
            $0.trailing.equalTo(plusButton.snp.leading).offset(-12)
        }
    }
}

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct HomeViewController_Preview: PreviewProvider {
    static var previews: some View {
        HomeViewController().showPreview()
    }
}
#endif
