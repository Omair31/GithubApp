//
//  GithubRepositoriesAPI.swift
//  GithubApp
//
//  Created by VenD-Omeir on 08/10/2021.
//

import Foundation

enum NetworkError: Error {
    case dataNotFound
    case dataNotDecodable
}

class GithubRepositoriesAPI: RepositoriesAPI {
    
    static let shared = GithubRepositoriesAPI(url: "https://api.github.com/search/repositories?q=language=+sort:stars")
    
    let url: String
    
    private init(url: String) {
        self.url = url
    }
    
    func fetchItems(completion: @escaping (Result<RepositoryListModel,Error>) -> Void) {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            if error != nil {
                completion(.failure(error!))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.dataNotFound))
                return
            }
            
            do {
                let repositoryListModel = try JSONDecoder().decode(RepositoryListModel.self, from: data)
                completion(.success(repositoryListModel))
            } catch {
                completion(.failure(NetworkError.dataNotDecodable))
            }
        }.resume()
    }
    
    
}
