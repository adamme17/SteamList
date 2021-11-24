//
//  GameListView.swift
//  SteamList
//
//  Created by Adam Bokun on 24.11.21.
//

import UIKit
import SnapKit

final class GameListView: UIView {

    // MARK: - UIElements
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }

    // MARK: - Setup
    internal func setupUI() {
        setup()
        updateConstraints()
    }
    
    internal func setup() {
        [tableView, titleLabel].forEach {addSubview($0)}
        backgroundColor = .red
    }

    // MARK: - Layout
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }

    override func updateConstraints() {
        super.updateConstraints()
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.height.equalTo(100.0)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(5.0)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }

    // MARK: - Update

    func update(state: GameListState) {
        titleLabel.text = state.title
        titleLabel.textColor = state.color
    }
}

struct GameListState {
    let title: String
    let color: UIColor
}
