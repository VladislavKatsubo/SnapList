//
//  SLTableView.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

class SLTableView: UITableView {

    init(style: UITableView.Style) {
        super.init(frame: .zero, style: style)
        setupItems()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func registerCells(_ cells: [SLTableViewCell.Type]) {
        cells.forEach({ register($0, forCellReuseIdentifier: $0.reuseID) })
    }

    func registerHeadersFooters(_ headersFooters: [SLSectionCell.Type]) {
        headersFooters.forEach({ register($0, forHeaderFooterViewReuseIdentifier: $0.reuseID) })
    }
}

private extension SLTableView {
    // MARK: - Private methods
    func setupItems() {
        backgroundColor = .clear
    }
    
}
