//
//  AddArticleViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift
import UIKit

protocol AddArticlePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AddArticleViewController: UIViewController, AddArticlePresentable, AddArticleViewControllable {

    weak var listener: AddArticlePresentableListener?
}
