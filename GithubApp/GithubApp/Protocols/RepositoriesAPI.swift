//
//  RepositoriesAPI.swift
//  GithubApp
//
//  Created by VenD-Omeir on 08/10/2021.
//

import Foundation

protocol RepositoriesAPI {
    func fetchItems(completion: @escaping (Result<RepositoryListModel,Error>) -> Void)
}


