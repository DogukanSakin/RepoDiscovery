//
//  RepositoryCell.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 19.05.2025.
//

import SnapKit
import UIKit

protocol RepositoryCellDelegate: AnyObject {
    func didTapBookmark(for repo: Repository)
}

final class RepositoryCell: UITableViewCell {
    static let identifier = "RepositoryCell"
    weak var delegate: RepositoryCellDelegate?
    private var currentRepo: Repository?

    // MARK: Container

    private let container: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        view.layer.cornerRadius = 10
        return view
    }()

    // MARK: Inner Container

    private let verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()

    // MARK: Name Label

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontNames.REGULAR, size: 16)
        label.textColor = .systemBlue
        label.numberOfLines = 1
        return label
    }()

    // MARK: Star Icon

    private let starIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray.withAlphaComponent(0.2)
        return imageView
    }()

    // MARK: Favorite Count Label

    private let favoriteCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontNames.REGULAR, size: 12)
        label.textColor = .systemGray
        return label
    }()

    // MARK: Description Label

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontNames.REGULAR, size: 8)
        label.textColor = .systemGray
        label.numberOfLines = 3
        return label
    }()

    // MARK: Owner Avatar Image

    private let ownerAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: Owner Name Label

    private let ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontNames.REGULAR, size: 12)
        label.numberOfLines = 1
        return label
    }()

    // MARK: Bookmark Icon

    private let bookmarkIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        bookmarkIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bookmarkTapped)))
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure

extension RepositoryCell {
    func configure(with repo: Repository) {
        nameLabel.text = repo.name
        favoriteCountLabel.text = "\(repo.stargazersCount)"
        descriptionLabel.text = repo.description
        ownerAvatarImageView.load(from: repo.owner.avatarURL)
        ownerNameLabel.text = repo.owner.login
        bookmarkIcon.image = repo.isBookmarked ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        currentRepo = repo
    }
}

// MARK: - Setup

extension RepositoryCell {
    private func setup() {
        // MARK: Favorite Container

        let favoriteHorizontalContainer = makeHorizontalStackView(arrangedSubviews: [starIcon, favoriteCountLabel])
        let ownerHorizontalContainer = makeHorizontalStackView(arrangedSubviews: [ownerAvatarImageView, ownerNameLabel])
        let bookmarkHorizontalContainer = makeHorizontalStackView(arrangedSubviews: [ownerHorizontalContainer, bookmarkIcon])
        bookmarkHorizontalContainer.distribution = .equalSpacing

        // MARK: Subviews

        verticalStackView.addArrangedSubview(bookmarkHorizontalContainer)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(favoriteHorizontalContainer)
        verticalStackView.addArrangedSubview(descriptionLabel)

        contentView.addSubview(container)
        container.addSubview(verticalStackView)

        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        starIcon.snp.makeConstraints { make in
            make.height.width.equalTo(16)
        }

        ownerAvatarImageView.snp.makeConstraints { make in
            make.height.width.equalTo(32)
        }

        bookmarkIcon.snp.makeConstraints { make in
            make.height.width.equalTo(16)
        }
    }

    private func makeHorizontalStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
}

// MARK: - Bookmark

extension RepositoryCell {
    @objc private func bookmarkTapped() {
        guard let repo = currentRepo else { return }
        delegate?.didTapBookmark(for: repo)
    }
}
