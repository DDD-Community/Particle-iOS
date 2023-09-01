//
//  PhotoPickerViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/19.
//

import RIBs
import RxSwift
import Photos
import UIKit

protocol PhotoPickerPresentableListener: AnyObject {
    
    func cancelButtonTapped()
    func nextButtonTapped(with images: [PHAsset])
}

final class PhotoPickerViewController: UIViewController,
                                       PhotoPickerPresentable,
                                       PhotoPickerViewControllable {
    
    enum Metric {
        enum NavigationBar {
            static let height = 44
            static let backButtonLeftMargin = 20
            static let nextButtonRightMargin = 20
        }
        enum CollectionViewCell {
            static let width = (DeviceSize.width-4)/3
        }
    }
    
    weak var listener: PhotoPickerPresentableListener?
    private var disposeBag: DisposeBag = .init()
    private var selectedIndexPaths: [IndexPath] = []
    
    private let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.black
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.xmarkButton, for: .normal)
        return button
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.text = "최근항목"
        label.font = .systemFont(ofSize: 19)
        label.textColor = .white
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.particleColor.main100, for: .normal)
        return button
    }()
    
    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: Metric.CollectionViewCell.width,
            height: Metric.CollectionViewCell.width
        )
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCell.self)
        collectionView.backgroundColor = .particleColor.black
        return collectionView
    }()
    
    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        configureButton()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        setupStatusBar()
    }
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
        navigationController?.isNavigationBarHidden = true
        addSubviews()
        setConstraints()
    }
    
    private func setupStatusBar() {
        let window = UIApplication.shared.windows.first
        let statusBarManager = window?.windowScene?.statusBarManager
        
        let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
        statusBarView.backgroundColor = .particleColor.black
        window?.addSubview(statusBarView)
    }
    
    private func configureButton() {
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.listener?.cancelButtonTapped()
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.listener?.nextButtonTapped(with: self.getSelectedPhotoes())
            }
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        bindCollectionViewCell()
        bindItemSelected()
    }
    
    private func bindCollectionViewCell() {
        Observable.of(Array(0...(photoCount - 1)))
            .bind(to: photoCollectionView.rx.items(
                cellIdentifier: PhotoCell.defaultReuseIdentifier,
                cellType: PhotoCell.self)
            ) { index, item, cell in
                
                guard let allPhotos = allPhotos else {
                    Console.error("\(#function) allPhotos 값이 존재하지 않습니다.")
                    return
                }
                cell.setImage(with: allPhotos.object(at: item))
            }
            .disposed(by: disposeBag)
    }
    
    private func bindItemSelected() {
        photoCollectionView
            .rx
            .itemSelected
            .subscribe { [weak self] indexPath in
                guard let self = self,
                      let indexPath = indexPath.element else { return }
                
                if self.selectedIndexPaths.contains(indexPath) {
                    self.selectedIndexPaths.remove(
                        at: self.selectedIndexPaths.firstIndex(of: indexPath) ?? .zero
                    )
                    guard let cell = self.getCell(at: indexPath) else { return }
                    cell.uncheck()
                } else {
                    self.selectedIndexPaths.append(indexPath)
                }
                
                for (order, indexPath) in self.selectedIndexPaths.enumerated() {
                    guard let cell = self.getCell(at: indexPath) else { return }
                    cell.check(number: order + 1)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func getSelectedPhotoes() -> [PHAsset] {
        guard let allPhotos = allPhotos else {
            Console.error("\(#function) allPhotos 값이 존재하지 않습니다.")
            return []
        }
        let selectedPhotoes = selectedIndexPaths.map {
            allPhotos.object(at: $0.row)
        }
        
        return selectedPhotoes
    }
    
    private func getCell(at indexPath: IndexPath?) -> PhotoCell? {
        guard let indexPath = indexPath else {
            Console.error("\(#function) indexPath가 존재하지 않습니다.")
            return nil
        }
        guard let cell = self.photoCollectionView.cellForItem(at: indexPath) as? PhotoCell else {
            return nil
        }
        return cell
    }
}

// MARK: - Layout Settting

private extension PhotoPickerViewController {
    func addSubviews() {
        [navigationBar, photoCollectionView].forEach {
            view.addSubview($0)
        }
        
        [cancelButton, navigationTitle, nextButton].forEach {
            navigationBar.addSubview($0)
        }
    }
    
    func setConstraints() {
        
        navigationBar.snp.makeConstraints {
            $0.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.NavigationBar.height)
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(Metric.NavigationBar.nextButtonRightMargin)
        }
        
        photoCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
