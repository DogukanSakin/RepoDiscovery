//
//  DiscoveryView.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 17.05.2025.
//

import SnapKit
import UIKit

final class DiscoveryView: UIView {
    let languageFilterView = LanguageFilterView()
    let repositoryListView = RepositoryListView()

    // MARK: Main View

    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()

    // MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Setups

extension DiscoveryView {
    private func addSubviews() {
        addSubview(mainView)
        mainView.addSubview(languageFilterView)
        mainView.addSubview(repositoryListView)
    }

    private func setup() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }

        languageFilterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(40)
        }

        repositoryListView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(languageFilterView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
}
