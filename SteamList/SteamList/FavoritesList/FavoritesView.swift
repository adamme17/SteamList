//
//  FavoritesView.swift
//  SteamList
//
//  Created by Adam Bokun on 28.12.21.
//

import UIKit
import SnapKit

final class FavoritesView: BackgroundView {
    
    // MARK: - UIElements
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .lightGray
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
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.tintColor = .white
        searchBar.searchTextField.leftView?.tintColor = .lightGray
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
    
    func update(state: FavoritesListState) {
        titleLabel.textColor = .white
        titleLabel.text = state.title
    }
}

struct FavoritesListState {
    let title: String
    let color: UIColor
}
