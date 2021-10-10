//
//  UITableViewCellExtension.swift
//  GithubApp
//
//  Created by VenD-Omeir on 10/10/2021.
//

import UIKit

extension UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}
