//
//  RepositoryListView.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 19.05.2025.
//

import SnapKit
import UIKit

protocol RepositoryListViewDelegate: AnyObject {
    func didTapBookmark(for repo: Repository)
    func didSelectRepository(_ repo: Repository)
}

final class RepositoryListView: UIView {
    weak var delegate: RepositoryListViewDelegate?

    // MARK: Data Source

    private typealias Section = Int
    private var dataSource: UITableViewDiffableDataSource<Section, Repository>!

    // MARK: Table View

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configureDataSource()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

extension RepositoryListView {
    private func setup() {
        backgroundColor = .systemBackground

        addSubview(tableView)

        tableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.identifier)
        tableView.rowHeight = 160
        tableView.estimatedRowHeight = 160
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Data Source

extension RepositoryListView {
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Repository>(tableView: tableView) { tableView, indexPath, repo in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.identifier, for: indexPath) as? RepositoryCell else {
                return UITableViewCell()
            }

            cell.configure(with: repo)
            cell.delegate = self
            return cell
        }
    }

    func applySnapshot(repos: [Repository], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Repository>()
        snapshot.appendSections([0])
        snapshot.appendItems(repos, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - Bookmark

extension RepositoryListView: RepositoryCellDelegate {
    func didTapBookmark(for repo: Repository) {
        delegate?.didTapBookmark(for: repo)
    }
}

extension RepositoryListView: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let repo = dataSource.itemIdentifier(for: indexPath) else { return }
        delegate?.didSelectRepository(repo)
    }
}
