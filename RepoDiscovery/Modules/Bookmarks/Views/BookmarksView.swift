//
//  BookmarksView.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 22.05.2025.
//

import SnapKit
import UIKit

final class BookmarksView: UIView {
    let repositoryListView = RepositoryListView()

    // MARK: View Models

    var bookmarkViewModel: BookmarkViewModel!

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

extension BookmarksView {
    private func addSubviews() {
        addSubview(mainView)
        mainView.addSubview(repositoryListView)
    }

    private func setup() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }

        repositoryListView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
}
