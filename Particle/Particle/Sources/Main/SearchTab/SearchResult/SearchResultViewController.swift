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
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SearchResultViewController: UIViewController, SearchResultPresentable, SearchResultViewControllable {

    weak var listener: SearchResultPresentableListener?
}
