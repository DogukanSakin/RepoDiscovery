//
//  DetailViewController.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 22.05.2025.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: Param

    var repository: Repository!

    // MARK: Views

    let detailView = DetailView()

    // MARK: Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.repository = repository
        let bookmarkImage = UIImage(systemName: repository.isBookmarked ? "bookmark.fill" : "bookmark")
        let bookmarkButton = UIBarButtonItem(
            image: bookmarkImage,
            style: .plain,
            target: self,
            action: #selector(didTapBookmark)
        )

        navigationItem.rightBarButtonItem = bookmarkButton
    }

    override func loadView() {
        super.loadView()
        view = detailView
    }

    // MARK: Inits

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTapBookmark() {
        Task {
            try await BookmarkService.shared.toggleBookmark(repository)
            repository.isBookmarked = !repository.isBookmarked
            navigationItem.rightBarButtonItem!.image = UIImage(systemName: repository.isBookmarked ? "bookmark.fill" : "bookmark")
        }
    }
}
