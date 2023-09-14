//
//  SectionTitle.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/09.
//

import UIKit
import SnapKit

final class SectionTitle: UIView {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.black
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let rightArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.arrowRight, for: .normal)
        return button
    }()
    
    // MARK: - Initializers
    
    init(title: String) {
        super.init(frame: .zero)
        addSubviews()
        setConstraints()
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Setting

private extension SectionTitle {
    
    func addSubviews() {
        [backgroundView].forEach {
            addSubview($0)
        }
        [titleLabel, rightArrowButton].forEach {
            backgroundView.addSubview($0)
        }
    }
    
    func setConstraints() {
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(7)
        }
        
        rightArrowButton.imageView?.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        rightArrowButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SectionTitle_Preview: PreviewProvider {
    
    static var previews: some View {
        SectionTitle(title: "UX/UI").showPreview()
    }
}
#endif
