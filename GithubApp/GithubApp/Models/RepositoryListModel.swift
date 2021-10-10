//
//  RepositoryListModel.swift
//  GithubApp
//
//  Created by VenD-Omeir on 08/10/2021.
//

import Foundation

struct RepositoryListModel: Decodable {
    
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]
    
    enum CodingKeys: String, CodingKey  {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
