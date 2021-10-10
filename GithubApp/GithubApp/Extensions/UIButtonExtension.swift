//
//  UIButtonExtension.swift
//  GithubApp
//
//  Created by VenD-Omeir on 10/10/2021.
//

import UIKit

extension UIButton {
    
    func setupStyle(title: String) {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.customGreen.cgColor
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.backgroundColor = .systemBackground
        self.setTitle(title, for: .normal)
        self.setTitleColor(.customGreen, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
}
