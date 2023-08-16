//
//  UIImage+ParticleImage.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import UIKit

extension UIImage {
    static let particleImage = ParticleImage()
}

struct ParticleImage {
    
    // MARK: - Button
    
    let backButton = UIImage(named: "backButtonIcon")
    let xmarkButton = UIImage(named: "xmark")
    let plusButton = UIImage(named: "plus")
    let refreshButton = UIImage(named: "refresh")
    
    let keyboardDownButton = UIImage(
        systemName: "keyboard.chevron.compact.down"
    )?.applyingSymbolConfiguration(
        .init(weight: .semibold)
    )
    
    // MARK: - Tab Icon
    
    let homeTabIcon = UIImage(named: "home")
    let searchTabIcon = UIImage(named: "search")
    let exploreTabIcon = UIImage(named: "book-open")
    let mypageTabIcon = UIImage(named: "user")
    
    // MARK: - Etc
    
    let checkBox = UIImage(named: "checkbox")
    let checkBox_checked = UIImage(named: "checkbox_checked")
    let loginBackground = UIImage(named: "loginBackground")
}
