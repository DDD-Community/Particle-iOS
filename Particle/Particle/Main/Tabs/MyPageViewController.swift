//
//  MyPageViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import UIKit

final class MyPageViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
    }
}
