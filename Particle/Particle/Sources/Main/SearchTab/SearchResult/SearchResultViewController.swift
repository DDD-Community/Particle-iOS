//
//  SearchResultViewController.swift
//  Particle
//
//  Created by Sh Hong on 2023/10/29.
//

import RIBs
import RxSwift
import UIKit

struct ResultCellModel {
    let title: String = "디자인에 공감능력이 필요한 4가지 이유"
    let subTitles: [String] = [
    "가설을 세운 후 검증을 제대로 해야 올바른 디자인을 제시할 수 있기 떄문에 검증은 꼭 필요하다.",
    "사용자 디자인에 필요한 리소스가 바로 공감이라는 것이다.",
    "어떤 어려움이 있는지 공감을 통해 그 과정을 알아야 한다. 이래서 정말 어렵겠구나 하는 공감이 있어야 개선시키고 싶은 디자인이 생긴다."
    ]
    let tags: [String] = [
    "#UX/UI", "#브랜딩"
    ]
}

protocol SearchResultPresentableListener: AnyObject {
}

final class SearchResultViewController: UIViewController, SearchResultPresentable, SearchResultViewControllable {

    weak var listener: SearchResultPresentableListener?
    var disposeBag = DisposeBag()
    
    private let mainView = SearchResultMainView()
    
    override func loadView() {
        self.view = SearchResultMainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dummy = [ResultCellModel]()
        for _ in 0...10 {
            let model = ResultCellModel()
            dummy.append(model)
        }
        
        Observable.of(dummy)
            .bind(to: mainView.searchResultTableView.rx.items(cellIdentifier: SearchResultListCell.defaultReuseIdentifier, cellType: SearchResultListCell.self)) { row, item, cell in
                cell.bind(title: item.title, subTitles: item.subTitles, tags: item.tags)
            }
            .disposed(by: disposeBag)
    }
}
