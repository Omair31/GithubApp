//
//  ItemsService.swift
//  GithubApp
//
//  Created by VenD-Omeir on 10/10/2021.
//

import Foundation

protocol ItemsService {
    func fetchItems(completion: @escaping (Result<[RepositoryViewModel],Error>) -> ())
}
