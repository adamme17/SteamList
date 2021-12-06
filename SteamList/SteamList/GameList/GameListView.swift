//
//  GameListView.swift
//  SteamList
//
//  Created by Adam Bokun on 24.11.21.
//

import UIKit
import SnapKit

final class GameListView: BackgroundView {

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
    
    lazy var searchBar: UISearchBar = {
            let searchBar = UISearchBar(frame: .zero)
            searchBar.backgroundColor = .clear
            searchBar.searchBarStyle = .minimal
            searchBar.isTranslucent = false
            searchBar.placeholder = "Search"
            return searchBar
        }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init() {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }

    // MARK: - Setup
    internal func setupUI() {
        self.backgroundColor = .clear
        self.tableView.backgroundColor = .clear
        setup()
        updateConstraints()
    }
    
    internal func setup() {
        [tableView, searchBar].forEach {addSubview($0)}
        backgroundColor = .clear
    }

    // MARK: - Layout
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    

    override func updateConstraints() {
        super.updateConstraints()
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.width.height.equalTo(100.0)
//        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).inset(5.0)
            make.leading.bottom.trailing.equalToSuperview()
        }
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50.0)
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
