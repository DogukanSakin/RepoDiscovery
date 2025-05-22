//
//  UIImageView+Extension.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 21.05.2025.
//

import UIKit

extension UIImageView {
    func load(from url: URL, placeholder: UIImage? = nil) {
        image = placeholder

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data)
            {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
