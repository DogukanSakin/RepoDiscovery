//
//  RepositoryService.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 17.05.2025.
//

import Alamofire
import Combine
import Foundation

final class RepositoryService {
    static let shared = RepositoryService()
    private let BASE_URL = "https://api.github.com/search/repositories"
    private let BASE_URL_BY_REPO_OWNER = "https://api.github.com/repos/"
    private init() {}

    func fetchRepositories(language: String = Config.DEFAULT_SELECTED_LANGUAGE) async throws -> RepositoryModel {
        let parameters: [String: String] = [
            "q": "language:\(language)",
            "sort": "stars",
            "order": "desc",
        ]

        let response: RepositoryModel = try await NetworkManager.shared.request(url: BASE_URL, parameters: parameters)
        return response
    }

    func fetchAllBookmarkedRepositories(bookmarks: [BookmarkedRepoModel]) async throws -> [Repository] {
        try await withThrowingTaskGroup(of: Repository.self) { group in
            for bookmark in bookmarks {
                group.addTask {
                    try await self.fetchBookmarkedRepository(repo: bookmark)
                }
            }

            var results: [Repository] = []
            for try await result in group {
                results.append(result)
            }

            return results
        }
    }

    private func fetchBookmarkedRepository(repo: BookmarkedRepoModel) async throws -> Repository {
        let url = "\(BASE_URL_BY_REPO_OWNER)\(repo.ownerName)/\(repo.repoName)"
        let response: Repository = try await NetworkManager.shared.request(url: url)
        return response
    }
}
