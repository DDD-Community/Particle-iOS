//
//  RecordCell.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/03.
//

import UIKit
import SnapKit

struct RecordCellModel {
    let id: String
    let createdAt: String
    let items: [(content: String, isMain: Bool)] // 3개만 받도록?
    let title: String
    let url: String
    
    static func stub() -> Self {
        .init(
            id: "1",
            createdAt: "2023-09-30T01:59:05.230Z",
            items: [
                ("개인적으로 나는 매일 글쓰는 일을 습관처럼 하고 있다.",false),
                ("그렇게 쓴 글은 매일 사회관계망서비스(SNS)에 남기기도 하고, 모아서 책으로 내기도 한다.", true),
                ("이런 습관들이 지금의 나를 만들어 줄 수 있었다.", false)
            ],
            title: "미니멀리스트의 삶",
            url: "www.naver.com"
        )
    }
}

final class RecordCell: UICollectionViewCell {
    
    enum Metric {
        
        enum SentenceBoxChild {
            static let height: CGFloat = 112
            static let horizontalMargin: CGFloat = 20
        }
    }
    
    // MARK: - UIComponents
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .p_headline,
            color: .particleColor.gray04,
            text: "6.23 화"
        )
        return label
    }()
    
    private let sentenceBox: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.gray01
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let sentenceBoxChild1: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.gray03
        view.layer.cornerRadius = 8
        // 회색일 때
        view.layer.borderColor = .particleColor.gray01.cgColor
        view.layer.borderWidth = 1
        view.transform = CGAffineTransform(rotationAngle: -.pi*(2.62/180))
        return view
    }()
    
    private let sentenceBoxChild1Label: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .p_body02,
            color: .white,
            text: "개인적으로 나는 매일 글쓰는 일을 습관처럼 하고 있다. 그렇게 쓴 글은 매일 사회관계망서비스(SNS)에 남기기도 하고, 모아서 책으로 내기도 한다."
        )
        label.numberOfLines = 0
        return label
    }()
    
    private let sentenceBoxChild2: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.gray03
        view.layer.cornerRadius = 8
        // 회색일 때
        view.layer.borderColor = .particleColor.gray01.cgColor
        view.layer.borderWidth = 1
        view.transform = CGAffineTransform(rotationAngle: .pi*(0.37/180))
        return view
    }()
    
    private let sentenceBoxChild2Label: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .p_body02,
            color: .white,
            text: "개인적으로 나는 매일 글쓰는 일을 습관처럼 하고 있다. 그렇게 쓴 글은 매일 사회관계망서비스(SNS)에 남기기도 하고, 모아서 책으로 내기도 한다."
        )
        label.numberOfLines = 0
        return label
    }()
    
    private let sentenceBoxChild3: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.gray03
        view.layer.cornerRadius = 8
        // 회색일 때
        view.layer.borderColor = .particleColor.gray01.cgColor
        view.layer.borderWidth = 1
        view.transform = CGAffineTransform(rotationAngle: -.pi*(2.62/180))
        return view
    }()
    
    private let sentenceBoxChild3Label: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .p_body02,
            color: .white,
            text: "개인적으로 나는 매일 글쓰는 일을 습관처럼 하고 있다. 그렇게 쓴 글은 매일 사회관계망서비스(SNS)에 남기기도 하고, 모아서 책으로 내기도 한다."
        )
        label.numberOfLines = 0
        return label
    }()
    
    private let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 15
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .p_footnote,
            color: .particleColor.gray04,
            text: "미니멀리스트 들여다보기"
        )
        return label
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .p_footnote,
            color: .particleColor.gray03,
            text: "www.testurl.com"
        )
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .particleColor.black
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        [sentenceBoxChild1, sentenceBoxChild2, sentenceBoxChild3].forEach {
            $0.backgroundColor = .particleColor.gray03
            $0.layer.borderColor = .particleColor.gray01.cgColor
            $0.layer.borderWidth = 1
        }
    }
    
    func setupData(data: RecordCellModel) {
        let labelList = [sentenceBoxChild1Label, sentenceBoxChild2Label, sentenceBoxChild3Label]
        let backList = [sentenceBoxChild1, sentenceBoxChild2, sentenceBoxChild3]
        
        for (i, item) in data.items.enumerated() {
            guard i < 3 else { break }
            
            labelList[i].text = item.content
            if item.isMain {
                backList[i].backgroundColor = .particleColor.main100
                backList[i].layer.borderWidth = 0
            }
        }
        
        dateLabel.text = DateManager.shared.convert(
            previousDate: data.createdAt,
            to: "M.dd (E)")
        titleLabel.text = data.title
        urlLabel.text = data.url
    }
}

// MARK: - Layout Settting

private extension RecordCell {
    
    func addSubviews() {
        [dateLabel, sentenceBox, bottomStack].forEach {
            contentView.addSubview($0)
        }
        
        [sentenceBoxChild1, sentenceBoxChild2, sentenceBoxChild3].forEach {
            sentenceBox.addSubview($0)
        }
        
        sentenceBoxChild1.addSubview(sentenceBoxChild1Label)
        sentenceBoxChild2.addSubview(sentenceBoxChild2Label)
        sentenceBoxChild3.addSubview(sentenceBoxChild3Label)
        
        [titleLabel, urlLabel].forEach {
            bottomStack.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        
        dateLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        sentenceBox.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(335)
        }
        
        sentenceBoxChild1.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(Metric.SentenceBoxChild.height)
        }
        sentenceBoxChild2.snp.makeConstraints {
            $0.top.equalTo(sentenceBoxChild1.snp.bottom).inset(16)
            $0.leading.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(Metric.SentenceBoxChild.height)
        }
        sentenceBoxChild3.snp.makeConstraints {
            $0.top.equalTo(sentenceBoxChild2.snp.bottom).inset(16)
            $0.leading.equalToSuperview().inset(25)
            $0.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(Metric.SentenceBoxChild.height)
        }
        
        sentenceBoxChild1Label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview().inset(14)
        }
        sentenceBoxChild2Label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview().inset(14)
        }
        sentenceBoxChild3Label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview().inset(14)
        }
        
        bottomStack.snp.makeConstraints {
            $0.top.equalTo(sentenceBox.snp.bottom).offset(12)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct RecordCell_Preview: PreviewProvider {
    
    static let cell: RecordCell = {
        let cell = RecordCell(frame: .init(origin: .zero, size: .init(width: DeviceSize.width, height: DeviceSize.width * 1.4)))
        cell.setupData(data: .stub())
        return cell
    }()

    static var previews: some View {
        cell.showPreview()
    }
}
#endif
