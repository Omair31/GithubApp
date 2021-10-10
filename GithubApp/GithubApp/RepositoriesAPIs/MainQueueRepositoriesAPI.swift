//
//  MainQueueRepositoriesAPI.swift
//  GithubApp
//
//  Created by VenD-Omeir on 10/10/2021.
//

import Foundation

class MainQueueGithubRepositoriesAPI: RepositoriesAPI {
    
    let repositoriesAPI: RepositoriesAPI
    
    init(repositoriesAPI: RepositoriesAPI) {
        self.repositoriesAPI = repositoriesAPI
    }
    
    func fetchItems(completion: @escaping (Result<RepositoryListModel, Error>) -> Void) {
        repositoriesAPI.fetchItems { (result) in
            DispatchQueue.main.asyncAfter(deadline: .now()  + 0.5) {
                completion(result)
            }
        }
    }
    
}
