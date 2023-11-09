//
//  SearchResultMainView.swift
//  Particle
//
//  Created by 홍석현 on 2023/11/05.
//

import UIKit

class SearchResultMainView: UIView {
    let searchResultTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    let emptyView: SearchResultEmptyView = {
        let view = SearchResultEmptyView()
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func layout() {
        [
            searchResultTableView,
            emptyView
        ]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            searchResultTableView.topAnchor.constraint(equalTo: self.topAnchor),
            searchResultTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            searchResultTableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            searchResultTableView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        
        NSLayoutConstraint.activate(
            [
                emptyView.topAnchor.constraint(equalTo: self.topAnchor),
                emptyView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                emptyView.leftAnchor.constraint(equalTo: self.leftAnchor),
                emptyView.rightAnchor.constraint(equalTo: self.rightAnchor)
            ]
        )
    }
}
