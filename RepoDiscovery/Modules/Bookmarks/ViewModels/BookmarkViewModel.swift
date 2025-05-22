//
//  BookmarkViewModel.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 21.05.2025.
//

import Combine
import Foundation
import SwiftData

@MainActor
final class BookmarkViewModel: ObservableObject {
    private let modelContext = DatabaseService.shared.context
    private let bookmarkService = BookmarkService.shared

    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var isLoading = false
    @Published private(set) var error: Error? = nil

    func toogleBookmark(_ repository: Repository) {
        Task {
            do {
                try await BookmarkService.shared.toggleBookmark(repository)
            } catch {
                self.error = error
            }
        }
    }

    func fetchBookmarkedRepos() async throws {
        isLoading = true

        do {
            try await BookmarkService.shared.fetchBookmarkedRepos()
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
