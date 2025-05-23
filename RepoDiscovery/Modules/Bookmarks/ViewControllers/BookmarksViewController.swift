//
//  BookmarksViewController.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 17.05.2025.
//

import Combine
import UIKit

class BookmarksViewController: UIViewController {
    // MARK: Views

    let bookmarksView = BookmarksView()
    let loaderView = LoaderView()

    // MARK: View Models

    var bookmarksViewModel: BookmarkViewModel!

    // MARK: Combine Props

    private var cancellables = Set<AnyCancellable>()

    // MARK: View Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        bookmarksView.repositoryListView.delegate = self
        bindViewModel()

        Task {
            try await bookmarksViewModel.fetchBookmarkedRepos()
        }
    }

    override func loadView() {
        super.loadView()
        view = bookmarksView
        view.addSubview(loaderView)

        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        title = NSLocalizedString("bookmarks", comment: "")
    }

    // MARK: Inits

    init(bookmarksViewModel: BookmarkViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.bookmarksViewModel = bookmarksViewModel
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Model Bindings

    func bindViewModel() {
        bookmarksViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loaderView.start()
                } else {
                    self?.loaderView.stop()
                }
            }
            .store(in: &cancellables)

        BookmarkService.shared.$bookmarkedRepositories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repositories in
                self?.bookmarksView.repositoryListView.applySnapshot(repos: repositories)
            }
            .store(in: &cancellables)

        bookmarksViewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self, let error = error else { return }
                let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default))
                self.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Bookmark Delegate

extension BookmarksViewController: RepositoryListViewDelegate {
    func didSelectRepository(_ repo: Repository) {
        let detailVC = DetailViewController()
        detailVC.repository = repo
        navigationController?.pushViewController(detailVC, animated: false)
    }

    func didTapBookmark(for repo: Repository) {
        bookmarksViewModel.toogleBookmark(repo)
    }
}
