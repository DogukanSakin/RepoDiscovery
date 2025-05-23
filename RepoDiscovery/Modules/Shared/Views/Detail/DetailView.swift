//
//  DetailView.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 22.05.2025.
//

import SnapKit
import UIKit

final class DetailView: UIView {
    // MARK: Param

    var repository: Repository! {
        didSet {
            configure()
            setup()
        }
    }

    // MARK: Scroll View

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    // MARK: Content Stack

    private let contentStack = UIStackView()

    // MARK: Owner Avatar Image

    private let ownerAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: Name Label

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontNames.REGULAR, size: 16)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()

    // MARK: Description Label

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontNames.REGULAR, size: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()

    // MARK: Divider

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()

    // MARK: Star Icon

    private let starIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star"))
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

    // MARK: Language Label

    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontNames.REGULAR, size: 12)
        label.textColor = .systemGray
        return label
    }()

    // MARK: Inits

    init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailView {
    private func configure() {
        ownerAvatarImageView.load(from: repository.owner.avatarURL)
        nameLabel.text = repository.name
        descriptionLabel.text = repository.description
        favoriteCountLabel.text = "\(repository.stargazersCount)"
        languageLabel.text = repository.language
    }

    private func setup() {
        addSubview(scrollView)
        scrollView.addSubview(contentStack)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(scrollView.snp.width).offset(-20)
            make.centerX.equalToSuperview()
        }

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.alignment = .fill

        setupHeader()
        setupContent()
    }

    private func setupHeader() {
        let headerStack = UIStackView(arrangedSubviews: [ownerAvatarImageView, nameLabel])
        headerStack.axis = .horizontal
        headerStack.spacing = 12

        ownerAvatarImageView.layer.cornerRadius = 20
        ownerAvatarImageView.clipsToBounds = true
        ownerAvatarImageView.snp.makeConstraints { make in
            make.height.width.equalTo(48)
        }

        contentStack.addArrangedSubview(headerStack)
    }

    private func setupContent() {
        let topDivider = makeDivider()
        let bottomDivider = makeDivider()
        let descriptionDivider = makeDivider()

        let starsCountStack = UIStackView(arrangedSubviews: [starIcon, favoriteCountLabel])
        starsCountStack.axis = .horizontal
        starsCountStack.spacing = 4
        starsCountStack.alignment = .fill

        let innerStack = UIStackView(arrangedSubviews: [starsCountStack, languageLabel])
        innerStack.axis = .horizontal
        innerStack.alignment = .center
        innerStack.distribution = .equalSpacing

        let viewOnGithubButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("View on GitHub", for: .normal)
            button.titleLabel?.font = UIFont(name: FontNames.SEMI_BOLD, size: 10)
            button.addTarget(self, action: #selector(handleViewOnGithubButtonTapped), for: .touchUpInside)
            return button
        }()

        let sectionStack = UIStackView(arrangedSubviews: [topDivider, innerStack, bottomDivider, descriptionLabel, descriptionDivider, viewOnGithubButton])
        sectionStack.axis = .vertical
        sectionStack.spacing = 8
        sectionStack.alignment = .fill

        contentStack.addArrangedSubview(sectionStack)
    }

    private func makeDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .systemGray6
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return divider
    }

    @objc private func handleViewOnGithubButtonTapped() {
        if UIApplication.shared.canOpenURL(repository.htmlURL) {
            UIApplication.shared.open(repository.htmlURL, options: [:], completionHandler: nil)
        }
    }
}
