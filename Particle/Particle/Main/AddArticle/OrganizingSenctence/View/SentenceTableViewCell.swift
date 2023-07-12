//
//  SentenceTableViewCell.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/11.
//

import UIKit
import SnapKit

final class SentenceTableViewCell: UITableViewCell {
    
    private enum Metric {
        static let bottomMargin: CGFloat = 10
        static let labelVerticalInset: CGFloat = 16
        static let labelHorizontalInset: CGFloat = 14
        static let labelCornerRadius: CGFloat = 12
    }
    
    private let sentenceLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.topInset = Metric.labelVerticalInset
        label.bottomInset = Metric.labelVerticalInset
        label.leftInset = Metric.labelHorizontalInset
        label.rightInset = Metric.labelHorizontalInset
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.1)
        label.layer.cornerRadius = Metric.labelCornerRadius
        label.clipsToBounds = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.addSubview(sentenceLabel)
        sentenceLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(Metric.bottomMargin)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sentenceLabel.preferredMaxLayoutWidth = sentenceLabel.frame.width
    }
    
    func setCellData(_ data: String) {
        sentenceLabel.text = data
        layoutSubviews()
    }
}
