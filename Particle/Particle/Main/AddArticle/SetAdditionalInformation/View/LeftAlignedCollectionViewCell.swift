//
//  LeftAlignedCollectionViewCell.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/13.
//

import UIKit
import SnapKit

class LeftAlignedCollectionViewCell: UICollectionViewCell {
    
    enum Metric {
        static let horizontalMargin = 24
        static let verticalMargin = 12
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        attribute()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        attribute()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func attribute() {
        self.backgroundColor = .init(red: 22, green: 22, blue: 22)
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    private func layout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Metric.verticalMargin)
            make.left.right.equalToSuperview().inset(Metric.horizontalMargin)
        }
    }
    
    func setSelected(_ selected: Bool) {
//        if selected {
//            self.backgroundColor = .bgPacificBlue
//            self.titleLabel.textColor = .white
//        } else {
//            self.backgroundColor = .bgGrey2
//            self.titleLabel.textColor = .bgSubGrey2
//        }
    }
    
}

