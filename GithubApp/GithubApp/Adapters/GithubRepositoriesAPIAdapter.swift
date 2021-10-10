//
//  GithubRepositoriesAPIAdapter.swift
//  GithubApp
//
//  Created by VenD-Omeir on 08/10/2021.
//

import Foundation

class GithubRepositoriesAPIAdapter: ItemsService {
    
    let api: RepositoriesAPI
    let select: (Repository) -> Void
    
    init(api: RepositoriesAPI, select: @escaping (Repository) -> Void) {
        self.api = api
        self.select = select
    }
    
    func fetchItems(completion: @escaping (Result<[RepositoryViewModel], Error>) -> Void) {
        api.fetchItems { (result) in
            switch result {
            case .success(let repositoryListModel):
                let items = repositoryListModel.items
                completion(.success(items.map({ (repository) in
                    return RepositoryViewModel(respository: repository, darkModeStarImage: "white_star", lightModeStarImage: "star") {
                        self.select(repository)
                    }
                })))
            case .failure(_):
                completion(.failure(NetworkError.dataNotFound))
            }
        }
    }
    
}
