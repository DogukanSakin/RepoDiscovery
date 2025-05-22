//
//  NetworkManager.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 17.05.2025.
//
import Alamofire

final class NetworkManager {
    private init() {}
    static let shared = NetworkManager()

    private let token = ""

    func request<T: Decodable>(url: String, parameters: [String: Any] = [:]) async throws -> T {
        if token.count == 0 {
            assertionFailure("Need token!")
        }

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: .get,
                parameters: parameters,
                headers: [
                    .authorization(bearerToken: token),
                ]
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
