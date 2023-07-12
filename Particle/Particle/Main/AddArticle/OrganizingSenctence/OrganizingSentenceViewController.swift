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
    
    private let organizingViewModels = BehaviorRelay<[OrganizingSentenceViewModel]>(value: [])
    
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
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func bind() {
        organizingViewModels
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
    
    func setUpData(with viewModels: [OrganizingSentenceViewModel]) {
        organizingViewModels.accept(viewModels)
    }
}
