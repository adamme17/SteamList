//
//  FilterView.swift
//  SteamList
//
//  Created by Adam Bokun on 18.01.22.
//

import UIKit

class FilterView: UIView {

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorColor = .lightGray
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.identifier)
        return tableView
    }()

    var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(rgb: 0x2B6386)
        button.layer.cornerRadius = 5
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        createSubViews()
    }

    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createSubViews()
    }

    private func createSubViews() {
        self.clipsToBounds = true
        self.backgroundColor = UIColor(rgb: 0x17364F)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1

        self.addSubview(tableView)
        self.addSubview(saveButton)

        tableView.snp.makeConstraints { (constraints) in
            constraints.top.leading.trailing.equalToSuperview()
        }

        saveButton.snp.makeConstraints { constraints in
            constraints.leading.equalToSuperview().offset(40)
            constraints.trailing.equalToSuperview().offset(-40)
            constraints.bottom.equalToSuperview().offset(-20)
            constraints.top.equalTo(tableView.snp.bottom).offset(20)
        }
    }
}
