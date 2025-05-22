//
//  DatabaseService.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 21.05.2025.
//

import SwiftData

class DatabaseService {
    static var shared = DatabaseService()
    var container: ModelContainer?
    var context: ModelContext?

    private init() {
        do {
            container = try ModelContainer(for: BookmarkedRepoModel.self)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            print("Error initializing database container:", error)
        }
    }
}
