//
//  OrganizingSentenceViewController.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/11.
//

import RIBs
import RxSwift
import UIKit

protocol OrganizingSentencePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class OrganizingSentenceViewController: UIViewController, OrganizingSentencePresentable, OrganizingSentenceViewControllable {

    weak var listener: OrganizingSentencePresentableListener?
}
