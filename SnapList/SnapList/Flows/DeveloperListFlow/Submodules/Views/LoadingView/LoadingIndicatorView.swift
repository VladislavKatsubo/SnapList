//
//  LoadingIndicatorView.swift
//  SnapList
//
//  Created by Vlad Katsubo on 25.09.23.
//

import UIKit

final class LoadingIndicatorView: SLView {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func didLoad() {
        super.didLoad()
        setupItems()
    }
}

private extension LoadingIndicatorView {
    // MARK: - Private methods
    func setupItems() {
        setupActivityIndicator()
    }
    
    func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
