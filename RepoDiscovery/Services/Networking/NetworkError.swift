//
//  NetworkError.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 17.05.2025.
//

import Alamofire
import Foundation

struct NetworkError: Error {
    let initialError: AFError
    let apiError: APIError?
}

struct APIError: Codable, Error {
    var status: String
    var message: String
}
