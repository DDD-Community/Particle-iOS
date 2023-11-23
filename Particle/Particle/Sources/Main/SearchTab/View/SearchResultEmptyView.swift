//
//  SearchResultEmptyView.swift
//  Particle
//
//  Created by Sh Hong on 2023/10/29.
//

import UIKit
import SnapKit

final class SearchResultEmptyView: UIView {
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .y_body01,
            color: .particleColor.gray03,
            text: "앗! 검색 결과가 없어요"
        )
        return label
    }()
    
    private let emptySubLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .p_body02,
            color: .particleColor.gray03,
            text: "다른 키워드로 검색해주세요"
        )
        return label
    }()
    
    private let emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .particleImage.eyes
        return imageView
    }()
    
    private let baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layout()
    }
    
    
    // MARK: - Layout
    private func layout() {
        [
            emptyImage,
            emptyLabel,
            emptySubLabel
        ]
            .forEach {
                baseStackView.addArrangedSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                }
            }
        
        addSubview(baseStackView)
        baseStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        baseStackView.setCustomSpacing(16, after: emptyImage)
        baseStackView.setCustomSpacing(6, after: emptyLabel)
    }
}
