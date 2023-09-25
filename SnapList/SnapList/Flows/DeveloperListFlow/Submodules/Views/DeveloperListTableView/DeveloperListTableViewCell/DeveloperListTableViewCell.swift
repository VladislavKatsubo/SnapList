//
//  DeveloperListTableViewCell.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

final class DeveloperListTableViewCell: SLTableViewCell {
    
    private enum Constants {
        static let containerViewLeadingOffset: CGFloat = 20.0
        static let containerViewTrailingInset: CGFloat = -20.0
        static let containerViewTopOffset: CGFloat = 10.0
        static let containerViewBottomInset: CGFloat = -10.0
        
        static let avatarImageViewOffset: CGFloat = 16.0
        static let avatarImageViewInset: CGFloat = -16.0
        static let avatarImageViewSize: CGSize = .init(width: 40.0, height: 40.0)
        
        static let verticalStackViewLeadingOffset: CGFloat = 16.0
        static let verticalStackViewSpacing: CGFloat = 6.0

        static let nameLabelFont: UIFont = .systemFont(ofSize: 16.0, weight: .regular)
        static let nameLabelFontColor: UIColor = .black

        static let idLabelFont: UIFont = .systemFont(ofSize: 14.0, weight: .light)
        static let idLabelFontColor: UIColor = .secondaryLabel
    }
    
    private let containerView = SLView()
    private let avatarImageView = AvatarImageView()
    private let verticalStackView = SLStackView(axis: .vertical, distribution: .fillEqually, spacing: Constants.verticalStackViewSpacing)
    private let idLabel = UILabel()
    private let nameLabel = UILabel()
    
    private var viewModel: DeveloperListTableViewCellViewModelProtocol?
    
    // MARK: - Lifecycle
    override func didLoad() {
        super.didLoad()
        setupItems()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cleanup()
    }
    
    // MARK: - Configure
    func configure(with viewModel: DeveloperListTableViewCellViewModelProtocol) {
        self.viewModel = viewModel
        setupViewModel()
    }
}

private extension DeveloperListTableViewCell {
    // MARK: - Private methods
    func setupViewModel() {
        self.viewModel?.onImageData = { [weak self] imageData in
            guard let self = self else { return }
            self.avatarImageView.configure(with: imageData)
        }
        self.viewModel?.onModelData = { [weak self] model in
            guard let self = self,
                  let id = model.id,
                  let name = model.name
            else {
                return
            }
            
            self.idLabel.text = "#" + String(id)
            self.nameLabel.text = name.capitalized
        }
        viewModel?.launch()
    }

    func setupItems() {
        self.backgroundColor = .clear

        setupContainerView()
        setupAvatarImageView()
        setupVerticalStackView()
        setupNameLabel()
        setupIdLabel()
    }

    func setupContainerView() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.containerViewTopOffset),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.containerViewLeadingOffset),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.containerViewTrailingInset),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.containerViewBottomInset),
        ])
    }

    func setupAvatarImageView() {
        containerView.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.clipsToBounds = true

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.avatarImageViewOffset),
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.avatarImageViewOffset),
            avatarImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: Constants.avatarImageViewInset),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarImageViewSize.width),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarImageViewSize.height)
        ])
    }

    func setupVerticalStackView() {
        containerView.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(idLabel)

        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.verticalStackViewLeadingOffset),
            verticalStackView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor)
        ])
    }

    func setupNameLabel() {
        nameLabel.font = Constants.nameLabelFont
        nameLabel.textColor = Constants.nameLabelFontColor
    }
    
    func setupIdLabel() {
        idLabel.font = Constants.idLabelFont
        idLabel.textColor = Constants.idLabelFontColor
    }

    func cleanup() {
        self.viewModel?.cancelImageDownload()
        self.avatarImageView.reset()
        self.idLabel.text = nil
        self.nameLabel.text = nil
    }
}
