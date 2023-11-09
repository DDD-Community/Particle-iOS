//
//  SearchResultViewController.swift
//  Particle
//
//  Created by Sh Hong on 2023/10/29.
//

import RIBs
import RxSwift
import UIKit

protocol SearchResultPresentableListener: AnyObject {
}

final class SearchResultViewController: UIViewController, SearchResultPresentable, SearchResultViewControllable {

    weak var listener: SearchResultPresentableListener?
    
    private var mainView: SearchResultMainView {
        view as! SearchResultMainView
    }
    
    override func loadView() {
        self.view = SearchResultMainView()
    }
}
