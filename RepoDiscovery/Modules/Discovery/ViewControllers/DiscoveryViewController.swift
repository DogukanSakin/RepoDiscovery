//
//  DiscoveryViewController.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 17.05.2025.
//

import Combine
import UIKit

class DiscoveryViewController: UIViewController {
    // MARK: Views

    let discoveryView = DiscoveryView()
    let loaderView = LoaderView()

    // MARK: View Models

    var discoveryViewModel: DiscoveryViewModel!

    // MARK: Combine Props

    private var cancellables = Set<AnyCancellable>()

    // MARK: Inits

    init(discoveryViewModel: DiscoveryViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.discoveryViewModel = discoveryViewModel
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        discoveryView.languageFilterView.delegate = self
        discoveryView.repositoryListView.delegate = self
        bindViewModel()

        Task {
            await discoveryViewModel.fetchRepositories(language: Config.DEFAULT_SELECTED_LANGUAGE)
        }
    }

    override func loadView() {
        super.loadView()
        view = discoveryView
        view.addSubview(loaderView)

        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        title = NSLocalizedString("discovery", comment: "")
    }

    // MARK: View Model Bindings

    func bindViewModel() {
        discoveryViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loaderView.start()
                } else {
                    self?.loaderView.stop()
                }
            }
            .store(in: &cancellables)

        discoveryViewModel.$repositories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repositories in
                self?.discoveryView.repositoryListView.applySnapshot(repos: repositories)
            }
            .store(in: &cancellables)

        discoveryViewModel.$error
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

// MARK: - Language Filter Delegate

extension DiscoveryViewController: LanguageFilterViewDelegate {
    func didSelectLanguage(_ language: String) {
        Task {
            await discoveryViewModel.fetchRepositories(language: language)
        }
    }
}

// MARK: - Bookmark Delegate

extension DiscoveryViewController: RepositoryListViewDelegate {
    func didSelectRepository(_ repo: Repository) {
        let detailVC = DetailViewController()
        detailVC.repository = repo
        navigationController?.pushViewController(detailVC, animated: false)
    }

    func didTapBookmark(for repo: Repository) {
        discoveryViewModel.toggleBookmark(for: repo)
    }
}
