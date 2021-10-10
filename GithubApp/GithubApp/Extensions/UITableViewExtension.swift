//
//  UITableViewExtension.swift
//  GithubApp
//
//  Created by VenD-Omeir on 10/10/2021.
//

import UIKit

extension UITableView {
    func registerCellFromNib(cellName:String) {
        let nib = UINib(nibName: cellName, bundle: Bundle.main)
        register(nib, forCellReuseIdentifier: cellName)
    }
}
