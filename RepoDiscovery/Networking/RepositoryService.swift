//
//  Service.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 17.05.2025.
//

import Alamofire
import Combine
import Foundation

protocol RepositoryServiceProtocol{
    
}

final class RepositoryService{
    static let shared = RepositoryService()
    
    private init(){}
    
    func fetchRepositories()async throws {
        print("called")
        let response:RepositoryModel = try await NetworkManager.shared.request()
        print(response.items)
        
    }
}


