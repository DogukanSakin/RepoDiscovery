//
//  DiscoveryViewModel.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 19.05.2025.
//

import Combine
import Foundation

@MainActor
final class DiscoveryViewModel: ObservableObject {
    private let bookmarkService = BookmarkService.shared
    private var cancellables = Set<AnyCancellable>()

    var bookmarkViewModel: BookmarkViewModel? = nil

    @Published private(set) var repositories: [Repository] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error? = nil

    init(bookmarkViewModel: BookmarkViewModel? = nil) {
        self.bookmarkViewModel = bookmarkViewModel
        observeBookmarks()
    }

    private func observeBookmarks() {
        bookmarkService.$bookmarkedRepositories
            .sink { [weak self] bookmarks in
                guard let self = self else { return }
                self.repositories = self.repositories.map { repo in
                    var updated = repo
                    updated.isBookmarked = bookmarks.contains(where: { $0.id == repo.id })
                    return updated
                }
            }
            .store(in: &cancellables)
    }

    func fetchRepositories(language: String) async {
        isLoading = true

        do {
            let response = try await RepositoryService.shared.fetchRepositories(language: language)

            let bookmarkedRepositories = await MainActor.run {
                response.items.map { repo in
                    var repo = repo
                    let isBookmarked = BookmarkService.shared.isBookmarked(repo)
                    repo.isBookmarked = isBookmarked
                    return repo
                }
            }

            repositories = bookmarkedRepositories
        } catch {
            self.error = error
        }

        isLoading = false
    }

    func toggleBookmark(for repo: Repository) {
        Task {
            do {
                try await BookmarkService.shared.toggleBookmark(repo)
            } catch {
                self.error = error
            }
        }
    }
}
