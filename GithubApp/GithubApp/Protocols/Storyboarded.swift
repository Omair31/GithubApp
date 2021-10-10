//
//  Storyboarded.swift
//  GithubApp
//
//  Created by VenD-Omeir on 08/10/2021.
//

import UIKit

protocol StoryBoarded {
    static func instantiate () -> Self
}

extension StoryBoarded where Self: UIViewController {
    
    static func instantiate () -> Self {
        let id = String(describing: self)
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyBoard.instantiateViewController(identifier: id) as! Self
    }
    
}
