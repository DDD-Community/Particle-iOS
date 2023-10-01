//
//  SectionTitle.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/09.
//

import UIKit
import SnapKit

final class SectionTitle: UICollectionReusableView {
    
    enum Metric {
        static let minimumHeight: CGFloat = 44
        static let titleLeadingMargin: CGFloat = 20
        static let titleTopMargin: CGFloat = 7
        static let buttonTrailingMargin: CGFloat = 8
        static let buttonSize: CGFloat = 20
        static let buttonTapSize: CGFloat = 40
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.info, for: .normal)
        return button
    }()
    
    private let rightArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.arrowRight, for: .normal)
        return button
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialView()
        addSubviews()
        setConstraints()
    }
    
    init() {
        super.init(frame: .zero)
        setupInitialView()
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        infoButton.isHidden = true
        titleLabel.text = nil
    }
    
    private func setupInitialView() {
        self.backgroundColor = .particleColor.black
        infoButton.isHidden = true
    }
    
    func setupData(title: String) {
        
        if title == "My" {
            
            titleLabel.attributedText = NSMutableAttributedString()
                .attributeString(
                    string: "나의 아티클",
                    font: .particleFont.generate(style: .ydeStreetB, size: 25),
                    textColor: .particleColor.white)
            infoButton.isHidden = false
        } else {
            
            titleLabel.attributedText = NSMutableAttributedString()
                .attributeString(
                    string: title,
                    font: .particleFont.generate(style: .ydeStreetB, size: 25),
                    textColor: .particleColor.main100)
                .attributeString(
                    string: " 태그에 담긴\n나의 아티클",
                    font: .particleFont.generate(style: .ydeStreetB, size: 25),
                    textColor: .particleColor.white)
        }
    }
}

// MARK: - Layout Setting

private extension SectionTitle {
    
    func addSubviews() {

        [titleLabel, infoButton, rightArrowButton].forEach {
            addSubview($0)
        }
    }
    
    func setConstraints() {
        self.snp.makeConstraints {
            $0.width.equalTo(DeviceSize.width)
            $0.height.greaterThanOrEqualTo(Metric.minimumHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Metric.titleLeadingMargin)
            $0.top.equalToSuperview().inset(Metric.titleTopMargin)
        }
        
        infoButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.width.height.equalTo(24)
        }
        
        rightArrowButton.imageView?.snp.makeConstraints {
            $0.width.height.equalTo(Metric.buttonSize)
        }
        
        rightArrowButton.snp.makeConstraints {
            $0.width.height.equalTo(Metric.buttonTapSize)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Metric.buttonTrailingMargin)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SectionTitle_Preview: PreviewProvider {
    
    static var sectionTitle: SectionTitle = {
        let sectionTitle = SectionTitle()
        sectionTitle.setupData(title: "My")
        return sectionTitle
    }()
    
    static var previews: some View {
        sectionTitle.showPreview()
    }
}
#endif
