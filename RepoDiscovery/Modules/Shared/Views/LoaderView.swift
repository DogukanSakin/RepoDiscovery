//
//  LoaderView.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 19.05.2025.
//

import SnapKit
import UIKit

final class LoaderView: UIView {
    private let loaderView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.backgroundColor = .systemBackground
        view.hidesWhenStopped = true
        return view
    }()

    // MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

extension LoaderView {
    private func setup() {
        addSubview(loaderView)

        loaderView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

// MARK: - Helpers

extension LoaderView {
    func start() {
        isHidden = false
        loaderView.startAnimating()
    }

    func stop() {
        isHidden = true
        loaderView.stopAnimating()
    }
}
