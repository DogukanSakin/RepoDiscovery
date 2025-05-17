//
//  DiscoveryViewController.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 17.05.2025.
//

import UIKit

class DiscoveryViewController: UIViewController {
    
    let discoveryView = DiscoveryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func loadView() {
        super.loadView()
        view = discoveryView
        
        Task {
            do {
                try await RepositoryService.shared.fetchRepositories()
            } catch {
                print("Hata oluştu: \(error)")
            }
        }
    }
}

