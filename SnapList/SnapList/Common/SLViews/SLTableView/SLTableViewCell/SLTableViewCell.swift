//
//  SLTableViewCell.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

class SLTableViewCell: UITableViewCell {

    static var reuseID: String { String(describing: self) }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        didLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func didLoad() {
        selectionStyle = .none
    }
}
