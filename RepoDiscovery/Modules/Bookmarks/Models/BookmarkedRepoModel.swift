//
//  BookmarkedRepoModel.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 21.05.2025.
//
import Foundation
import SwiftData

@Model
class BookmarkedRepoModel {
    var id: Int
    var repoName: String
    var ownerName: String
    var addedAt: Date

    init(id: Int, repoName: String, ownerName: String) {
        self.id = id
        self.repoName = repoName
        self.ownerName = ownerName
        addedAt = Date()
    }
}
