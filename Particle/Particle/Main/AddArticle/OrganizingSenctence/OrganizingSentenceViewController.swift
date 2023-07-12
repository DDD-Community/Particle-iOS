//
//  OrganizingSentenceViewController.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/11.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import RxCocoa

protocol OrganizingSentencePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class OrganizingSentenceViewController: UIViewController, OrganizingSentencePresentable, OrganizingSentenceViewControllable {

    weak var listener: OrganizingSentencePresentableListener?
    private var disposeBag: DisposeBag = .init()
    
    enum Metric {
        enum Title {
            static let topMargin = 12
            static let leftMargin = 20
        }
        
        enum TableView {
            static let topMargin = 23
            static let horizontalMargin = 20
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.text = "문장 순서와 대표 문장을 설정하세요"
        label.textColor = .white
        return label
    }()
    
    private let sentenceTableView: UITableView = {
        let table = UITableView()
        table.register(SentenceTableViewCell.self)
        table.backgroundColor = .clear
        table.alwaysBounceVertical = false
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 50
        return table
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
        self.view.backgroundColor = .black
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.of([
            "그렇게 쓴 글은 매일 사회관계망서비스(SNS)에 남기기도 하고, 모아서 책으로 내기도 한다.",
            "개인적으로 나는 매일 글쓰는 일을 습관처럼 하고 있다. ",
            "그러나 처음부터 글을 습관처럼 매일 쓸 수 있었던 건 아니다.",
            "하지만 당시에는 작가가 되고 싶다는 열망 하나를 갖고 있었고, 그 젊은 열망에 따라 어떻게든 무엇이든 글을 쓰고자 했다. ",
            "많은 사람들이 내게 그렇게 매일 글을 쓸 수 있는 비결을 물어보곤 하는데, 나는 그저 습관이 되어버렸다고 말할 수밖에 없다."
                      ])
        .bind(to: sentenceTableView.rx.items(cellIdentifier: SentenceTableViewCell.defaultReuseIdentifier, cellType: SentenceTableViewCell.self)) { index, item, cell in
            cell.setCellData(item)
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - Add Subviews
    private func addSubviews() {
        [titleLabel,
        sentenceTableView]
            .forEach {
                self.view.addSubview($0)
            }
    }
    
    // MARK: - Layout
    private func layout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(Metric.Title.topMargin)
            make.left.equalTo(self.view.safeAreaLayoutGuide).inset(Metric.Title.leftMargin)
        }
        
        sentenceTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.TableView.topMargin)
            make.left.right.equalToSuperview().inset(Metric.TableView.horizontalMargin)
            make.bottom.equalToSuperview()
        }
    }
}
