//
//  SLCircleImageView.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

class SLCircleImageView: UIImageView {

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = bounds.width / 2.0
    }
}
