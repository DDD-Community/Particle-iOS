//
//  PhotoCell.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/20.
//

import UIKit

import RxSwift
import Photos

class CacheManager {
    static let shared = CacheManager()
    private let imageCache = NSCache<NSString, UIImage>()

    private init() {
        // 싱글톤 패턴을 위한 private 초기화 메서드
    }

    func cacheImage(_ image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }

    func image(forKey key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
}

//class ImageDiskCacheManager {
//    static let shared = ImageDiskCacheManager()
//
//    private let cacheDirectory: URL
//
//    private init() {
//        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
//        cacheDirectory = cachesDirectory.appendingPathComponent("ImageCache")
//
//        // 캐시 디렉토리를 생성합니다.
//        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
//            do {
//                try FileManager.default.createDirectory(atPath: cacheDirectory.path, withIntermediateDirectories: true, attributes: nil)
//            } catch {
//                print("Failed to create image cache directory: \(error)")
//            }
//        }
//    }
//
//    func cacheImage(_ image: UIImage, forKey key: String) {
//        let fileURL = cacheDirectory.appendingPathComponent(key)
//        if let data = image.jpegData(compressionQuality: 0.8) {
//            do {
//                try data.write(to: fileURL)
//            } catch {
//                print("Failed to write image data to cache: \(error)")
//            }
//        }
//    }
//
//    func image(forKey key: String) -> UIImage? {
//        let fileURL = cacheDirectory.appendingPathComponent(key)
//        if FileManager.default.fileExists(atPath: fileURL.path) {
//            if let imageData = try? Data(contentsOf: fileURL),
//                let image = UIImage(data: imageData) {
//                return image
//            }
//        }
//        return nil
//    }
//}
final class PhotoCell: UICollectionViewCell {
    
    private var disposeBag = DisposeBag()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let checkBox: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .particleImage.checkBox
        return imageView
    }()
    
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()
    
    private let checkBox_checked: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .particleImage.checkBox_checked
        return imageView
    }()
    
    private let numberLabel: UILabel = {
        let number = UILabel()
        number.font = .systemFont(ofSize: 12)
        number.textColor = .white
        return number
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
        contentView.clipsToBounds = true
        checkBox_checked.alpha = 0
        dimmingView.alpha = 0
        numberLabel.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        disposeBag = DisposeBag()
    }
    
    func setImage(with asset: PHAsset) {
//        imageView.fetchImage(
//            asset: asset,
//            contentMode: .default,
//            targetSize: imageView.frame.size
//        )
        
        if let cachedImage = CacheManager.shared.image(forKey: asset.localIdentifier) {
            self.imageView.image = cachedImage
        } else {
            fetchImage(asset: asset, contentMode: .default, targetSize: imageView.frame.size).subscribe { [ weak self] image in
                self?.imageView.image = image
            }
            .disposed(by: disposeBag)
        }
        
//        if let cachedImage = ImageDiskCacheManager.shared.image(forKey: asset.localIdentifier) {
//            self.imageView.image = cachedImage
//        } else {
//            fetchImage(asset: asset, contentMode: .default, targetSize: imageView.frame.size).subscribe { [ weak self] image in
//                self?.imageView.image = image
//            }
//            .disposed(by: disposeBag)
//        }
    }
    
    func check(number: Int) {
        dimmingView.alpha = 0.3
        checkBox_checked.alpha = 1
        numberLabel.alpha = 1
        numberLabel.text = "\(number)"
    }
    
    func uncheck() {
        dimmingView.alpha = 0
        checkBox_checked.alpha = 0
        numberLabel.alpha = 0
    }
    
    private func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) -> Observable<UIImage> {
        let options = PHImageRequestOptions()
        options.version = .original
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        
        return Observable.create { emitter in
        
            PHCachingImageManager().requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: contentMode,
                options: options) { image, info in
                    
                    if let image = image {
                        CacheManager.shared.cacheImage(image, forKey: asset.localIdentifier)
//                        ImageDiskCacheManager.shared.cacheImage(image, forKey: asset.localIdentifier)
                        emitter.onNext(image)
                    } else {
                        Console.error("\(#function) image 가 존재하지 않습니다.")
                    }
                }
            
            return Disposables.create()
        }
    }
}

// MARK: - Layout Settting

private extension PhotoCell {
    
    func addSubviews() {
        [
            imageView,
            dimmingView,
            checkBox,
            checkBox_checked,
            numberLabel
        ]
            .forEach {
                contentView.addSubview($0)
            }
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(contentView)
        }
        dimmingView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(contentView)
        }
        checkBox.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.trailing.equalToSuperview().inset(8)
        }
        checkBox_checked.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.center.equalTo(checkBox)
        }
        numberLabel.snp.makeConstraints {
            $0.center.equalTo(checkBox_checked)
        }
    }
}
