//
//  NewsView.swift
//  SteamList
//
//  Created by Adam Bokun on 10.12.21.
//

import UIKit
import SnapKit

class NewsView: BackgroundView {
    
    // MARK: - UIElements
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorColor = .lightGray
        return tableView
    }()
    
    var topFilterViewConstraint: Constraint?
    
    var filterView: FilterView = {
        let filterView = FilterView()
        return filterView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0
        return blurView
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
        [tableView].forEach {addSubview($0)}
        backgroundColor = .clear
    }
    
    // MARK: - Layout
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        tableView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func setupFilterView() {
        self.addSubview(filterView)

        filterView.snp.makeConstraints { constraints in
            topFilterViewConstraint = constraints.top.equalTo(self.bounds.height).constraint
            constraints.centerX.equalToSuperview()
            constraints.width.equalTo(self.frame.width * 0.65)
            constraints.height.equalTo(self.frame.height * 0.4)
        }
        self.layoutIfNeeded()
    }
    
    func addBlur() {
        self.addSubview(blurView)
        blurView.snp.makeConstraints { constraints in
            constraints.edges.equalToSuperview()
        }
        self.layoutIfNeeded()
    }

    func deleteBlur() {
        blurView.removeFromSuperview()
    }
    
    // MARK: - Update
    
    func update(state: NewsListState) {
        titleLabel.textColor = .white
        titleLabel.text = state.title
    }
}


struct NewsListState {
    let title: String
    let color: UIColor
}

