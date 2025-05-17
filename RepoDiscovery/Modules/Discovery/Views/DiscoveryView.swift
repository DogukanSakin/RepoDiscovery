//
//  DiscoveryView.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 17.05.2025.
//

import UIKit
import SnapKit

final class DiscoveryView:UIView{
    // MARK: Main View
    
    private let mainView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    // MARK: Title Label
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("discovery",comment: "")
        label.font = UIFont(name:FontNames.SEMI_BOLD, size: 24)
        return label
    }()
    
    // MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Setups

extension DiscoveryView{
    private func addSubviews(){
        addSubview(mainView)
        mainView.addSubview(titleLabel)
    }
    
    private func setup(){
        // MARK: Main View
        mainView.snp.makeConstraints{ make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        // MARK: Title Label
        titleLabel.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview()
        }
    }
    
    
}
