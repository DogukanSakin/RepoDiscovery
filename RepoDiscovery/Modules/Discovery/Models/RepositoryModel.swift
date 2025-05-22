//
//  RepositoryModel.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 17.05.2025.
//

import Foundation

// MARK: - RepositoryModel

struct RepositoryModel: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - Repository

struct Repository: Decodable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let htmlURL: URL
    let stargazersCount: Int
    let language: String?
    let owner: Owner
    var isBookmarked: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case description
        case htmlURL = "html_url"
        case stargazersCount = "stargazers_count"
        case language
        case owner
    }
}

// MARK: - Owner

struct Owner: Decodable {
    let login: String
    let id: Int
    let avatarURL: URL

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarURL = "avatar_url"
    }
}

// MARK: - Hashable

extension Repository: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(isBookmarked)
    }

    static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.id == rhs.id && lhs.isBookmarked == rhs.isBookmarked
    }
}

extension Owner: Hashable {
    static func == (lhs: Owner, rhs: Owner) -> Bool {
        lhs.id == rhs.id
    }
}
