//
//  SLImageView.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

class SLImageView: UIImageView {

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        didLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func didLoad() {
        tintColor = .white
        contentMode = .scaleAspectFit
        clipsToBounds = true
    }
}
