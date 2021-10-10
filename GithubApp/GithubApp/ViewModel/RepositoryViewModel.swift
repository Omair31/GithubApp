//
//  RepositoryViewModel.swift
//  GithubApp
//
//  Created by VenD-Omeir on 08/10/2021.
//

import UIKit

class RepositoryViewModel {
    
    let title: String
    let subtitle: String
    let description: String
    let language: String
    let stars: String
    let imageURL: String
    let darkModeStarImage: String
    let lightModeStarImage: String
    let select: () -> ()
    
    init(respository: Repository, darkModeStarImage: String, lightModeStarImage:String, select: @escaping () -> ()) {
        self.title = respository.fullName
        self.subtitle = respository.name
        self.description = respository.repositoryDescription
        self.language = respository.language ?? ""
        self.stars = "\(respository.stargazersCount)"
        self.imageURL = respository.owner.avatarURL
        self.darkModeStarImage = darkModeStarImage
        self.lightModeStarImage = lightModeStarImage
        self.select = select
    }
    
    
}
