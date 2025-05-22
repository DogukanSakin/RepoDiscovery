//
//  BookmarkService.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 22.05.2025.
//
import Combine
import Foundation
import SwiftData

@MainActor
final class BookmarkService: ObservableObject {
    static let shared = BookmarkService()

    private let modelContext = DatabaseService.shared.context
    @Published private(set) var bookmarkedRepositories: [Repository] = []

    private init() {
        Task {
            try await fetchBookmarkedRepos()
        }
    }

    func fetchBookmarkedRepos() async throws {
        let descriptor = FetchDescriptor<BookmarkedRepoModel>(sortBy: [SortDescriptor(\.addedAt, order: .reverse)])
        let bookmarks: [BookmarkedRepoModel] = (try? modelContext?.fetch(
            descriptor)) ?? []

        if let repos = try? await RepositoryService.shared.fetchAllBookmarkedRepositories(bookmarks: bookmarks) {
            let repoDict = Dictionary(uniqueKeysWithValues: repos.map { ($0.id, $0) })

            bookmarkedRepositories = bookmarks.compactMap { bookmark in
                guard var repo = repoDict[bookmark.id] else { return nil }
                repo.isBookmarked = true
                return repo
            }
        }
    }

    func isBookmarked(_ repository: Repository) -> Bool {
        bookmarkedRepositories.contains(where: { $0.id == repository.id })
    }

    func toggleBookmark(_ repository: Repository) async throws {
        let isAlreadyBookmarked = isBookmarked(repository)
        let id = repository.id

        if isAlreadyBookmarked {
            try modelContext?.delete(model: BookmarkedRepoModel.self, where: #Predicate { $0.id == id })

            if let index = bookmarkedRepositories.firstIndex(where: { $0.id == repository.id }) {
                bookmarkedRepositories.remove(at: index)
            }
        } else {
            let bookmark = BookmarkedRepoModel(id: id, repoName: repository.name, ownerName: repository.owner.login)
            modelContext?.insert(bookmark)
            var repository = repository
            repository.isBookmarked = true
            bookmarkedRepositories.insert(repository, at: 0)
        }

        try modelContext?.save()
    }
}
