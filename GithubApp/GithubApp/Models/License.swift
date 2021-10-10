//
//  License.swift
//  GithubApp
//
//  Created by VenD-Omeir on 08/10/2021.
//

import Foundation

// MARK: - License
struct License: Codable {
    let key, name, spdxID: String
    let nodeID: String

    enum CodingKeys: String, CodingKey {
        case key, name
        case spdxID = "spdx_id"
        case nodeID = "node_id"
    }
}
