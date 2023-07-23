//
//  PhotoCell.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/20.
//

import UIKit
import Photos

final class PhotoCell: UICollectionViewCell {
    
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
    }
    
    func setImage(with asset: PHAsset) {
        imageView.fetchImage(
            asset: asset,
            contentMode: .default,
            targetSize: imageView.frame.size
        )
    }
    
    func check(number: Int) {
        if checkBox_checked.alpha == 0 {
            dimmingView.alpha = 0.3
            checkBox_checked.alpha = 1
            numberLabel.alpha = 1
            numberLabel.text = "\(number)"
        } else {
            dimmingView.alpha = 0
            checkBox_checked.alpha = 0
            numberLabel.alpha = 0
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
