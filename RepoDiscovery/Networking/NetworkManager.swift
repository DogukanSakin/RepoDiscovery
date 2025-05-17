//
//  NetworkManager.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 17.05.2025.
//
import Alamofire

final class NetworkManager{
    private init(){}
    static let shared = NetworkManager()
    
    private let BASE_URL = "https://api.github.com/search/repositories"
    private let token = ""
    
    func request<T:Decodable>()async throws->T{
        return try await withCheckedThrowingContinuation { continuation in
            let parameters: [String: String] = [
                "q": "language:swift",
                "sort": "stars",
                "order": "desc"
            ]
            
            AF.request(
                BASE_URL,
                method:.get,
                parameters: parameters,
                headers: [
                    .authorization(bearerToken: token)
                ]
            )
            .validate()
            .responseDecodable(of: T.self){ response in
                switch(response.result) {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
