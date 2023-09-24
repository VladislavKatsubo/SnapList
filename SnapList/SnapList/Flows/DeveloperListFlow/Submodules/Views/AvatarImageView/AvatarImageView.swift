//
//  AvatarImageView.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

final class AvatarImageView: SLView {
    // MARK: - Constants
    private enum Constants {
        static let placeholderImageName: String = "person.fill"
    }

    private let imageView = SLCircleImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Public methods
    override func didLoad() {
        super.didLoad()
        setupItems()
    }

    // MARK: - Configure
    func configure(with imageData: Data?) {
        self.activityIndicator.stopAnimating()
        guard let imageData = imageData else {
            self.imageView.image = UIImage(systemName: Constants.placeholderImageName)
            return
        }
        self.imageView.image = UIImage(data: imageData)
        
    }

    // MARK: - Public methods
    func reset() {
        self.imageView.image = nil
        self.activityIndicator.startAnimating()
    }
}

private extension AvatarImageView {
    // MARK: - Private methods
    func setupItems() {
        setupImageView()
        setupActivityIndicator()
    }

    func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
