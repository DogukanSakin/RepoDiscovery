//
//  LanguageFilterView.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 19.05.2025.
//
import SnapKit
import UIKit

protocol LanguageFilterViewDelegate: AnyObject {
    func didSelectLanguage(_ language: String)
}

final class LanguageFilterView: UIView {
    let scrollView = UIScrollView()
    let stackView = UIStackView()

    weak var delegate: LanguageFilterViewDelegate?

    // MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addFilterButtons()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

extension LanguageFilterView {
    private func setup() {
        backgroundColor = .systemBackground

        // MARK: Scroll View

        scrollView.showsHorizontalScrollIndicator = false

        addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }

        // MARK: Stack View

        stackView.axis = .horizontal
        stackView.spacing = 10

        scrollView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}

// MARK: - Add Filter Buttons

extension LanguageFilterView {
    private func addFilterButtons() {
        for language in Config.LANGUAGES {
            let button = UIButton(type: .system)
            button.setTitle(language, for: .normal)
            button.setTitleColor(language == Config.DEFAULT_SELECTED_LANGUAGE ? .white : .label, for: .normal)
            button.titleLabel?.font = UIFont(name: FontNames.REGULAR, size: 12)
            button.layer.cornerRadius = 20
            button.backgroundColor = language == Config.DEFAULT_SELECTED_LANGUAGE ? .systemBlue : .lightGray.withAlphaComponent(0.2)
            button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: 100).isActive = true

            stackView.addArrangedSubview(button)
        }
    }

    @objc private func handleTap(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }

        delegate?.didSelectLanguage(title)

        for case let button as UIButton in stackView.arrangedSubviews {
            button.backgroundColor = (button.titleLabel?.text == title) ? .systemBlue : .lightGray.withAlphaComponent(0.2)
            button.setTitleColor(button.titleLabel?.text == title ? .white : .label, for: .normal)
        }
    }
}
