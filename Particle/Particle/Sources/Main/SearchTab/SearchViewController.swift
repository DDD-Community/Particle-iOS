//
//  SearchViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift
import UIKit

protocol SearchPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {

    weak var listener: SearchPresentableListener?
    
    private var tags: [(title: String, isSelected: Bool)] = {
        let tags = [
            "UX/UI",
            "브랜드",
            "트렌드",
            "서비스기획",
            "그로스마케팅"
            ]
        return tags.map { ($0, false) }
    }()
    
    var disposeBag = DisposeBag()
    
    private enum Metric {
        enum SearchBar {
            static let topMargin = 24
            static let horizontalMargin = 20
            static let height = 48
        }
        
        enum ListTitle {
            static let topMargin = 32
            static let leftMargin = 20
        }
        
        enum RemoveButton {
            static let rightMargin = 8
        }
        
        enum List {
            static let horizontalMargin = 20
            static let topMargin = 12
        }
        
        enum TagTitle {
            static let topMargin = 65
            static let leftMargin = 20
        }
        
        enum Tags {
            static let topMagin: CGFloat = 12
            static let horizontalMargin: CGFloat = 20
            static let minimumLineSpacing: CGFloat = 10
            static let minimumInterItemSpacing: CGFloat = 10
        }
    }
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .clear
        searchBar.tintColor = .clear
        searchBar.placeholder = "검색어를 입력해 주세요."
        searchBar.searchTextField.font = .particleFont.generate(style: .pretendard_Regular, size: 16)
        return searchBar
    }()
    
    private let recentSearchListTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.setParticleFont(.y_headline, color: .particleColor.gray04)
        return label
    }()
    
    private let recentSearchListRemoveButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: 10, leading: 12, bottom: 10, trailing: 12)
        configuration.attributedTitle = AttributedString("모두 지우기", attributes: AttributeContainer.init([
            .font: UIFont.particleFont.generate(style: .pretendard_Regular, size: 12) ?? UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.particleColor.gray03
        ]))
        
        button.configuration = configuration
        return button
    }()
    
    private let recentSearchList: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchListCell.self)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let tagTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 태그로 검색"
        label.setParticleFont(.y_headline, color: .particleColor.gray04)
        return label
    }()
    
    private let tagCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.minimumLineSpacing = Metric.Tags.minimumLineSpacing
        layout.minimumInteritemSpacing = Metric.Tags.minimumInterItemSpacing
        
        let collectionView = DynamicHeightCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(LeftAlignedCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "검색"
        tabBarItem.image = .particleImage.searchTabIcon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        addSubviews()
        setConstraints()
        
        Observable.of([
        "최근 검색어어어어",
        "최근 검색어어어어",
        "최근 검색어어어어",
        "최근 검색어어어어",
        "최근 검색어어어어"
        ])
        .bind(to: recentSearchList.rx.items(
            cellIdentifier: SearchListCell.defaultReuseIdentifier,
            cellType: SearchListCell.self)
        ) { tableView, item, cell in
            cell.bind(item)
        }
        .disposed(by: disposeBag)
        
        Observable.of(tags)
        .bind(to: tagCollectionView.rx.items(
            cellIdentifier: LeftAlignedCollectionViewCell.defaultReuseIdentifier,
            cellType: LeftAlignedCollectionViewCell.self
        )) { collectionView, item, cell in
            cell.titleLabel.text = item.title
        }
            .disposed(by: disposeBag)
        
        tagCollectionView.rx.itemSelected
            .subscribe { [weak self] indexPath in
            guard let self = self else { return }
            guard let index = indexPath.element else { return }
            guard let selectedCell = self.tagCollectionView.cellForItem(at: index) as? LeftAlignedCollectionViewCell else {
                return
            }
            selectedCell.setSelected()
            self.tags[index.row].isSelected.toggle()
        }
        .disposed(by: disposeBag)
    }
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Layout Setting

private extension SearchViewController {
    func addSubviews() {
        [searchBar]
               .forEach {
                   self.view.addSubview($0)
               }
        
        [
            recentSearchListTitleLabel,
            recentSearchListRemoveButton,
            recentSearchList
        ]
            .forEach {
                self.view.addSubview($0)
            }
        
        [tagTitleLabel, tagCollectionView]
            .forEach {
                self.view.addSubview($0)
            }
       }
    
    func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(Metric.SearchBar.topMargin)
            make.left.right.equalToSuperview().inset(Metric.SearchBar.horizontalMargin)
            make.height.equalTo(Metric.SearchBar.height)
        }
        
        recentSearchListTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Metric.ListTitle.topMargin)
            make.left.equalToSuperview().inset(Metric.ListTitle.leftMargin)
        }
        
        recentSearchListRemoveButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearchListTitleLabel)
            make.right.equalToSuperview().inset(Metric.RemoveButton.rightMargin)
        }
        
        recentSearchList.snp.makeConstraints { make in
            make.top.equalTo(recentSearchListTitleLabel.snp.bottom).offset(Metric.List.topMargin)
            make.left.right.equalToSuperview().inset(Metric.List.horizontalMargin)
            make.height.equalTo(45 * 5)
        }
        
        tagTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(recentSearchList.snp.bottom).offset(Metric.TagTitle.topMargin)
            make.left.equalToSuperview().inset(Metric.TagTitle.leftMargin)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagTitleLabel.snp.bottom).offset(Metric.Tags.topMagin)
            make.left.right.equalToSuperview().inset(Metric.Tags.horizontalMargin)
            make.bottom.lessThanOrEqualToSuperview().offset(14)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI
import AuthenticationServices

@available(iOS 13.0, *)
struct SearchViewController_Preview: PreviewProvider {
    static var previews: some View {
        SearchViewController().showPreview()
    }
}
#endif
