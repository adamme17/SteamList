//
//  NewsCell.swift
//  SteamList
//
//  Created by Adam Bokun on 13.12.21.
//

import Foundation
import UIKit

class NewsCell: UITableViewCell {

    var safeArea: UILayoutGuide!
    let nameLabel = UILabel()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let dateLabel = UILabel()
    let storageManager = CoreDataManager.shared()
    var games: Details?
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cellViewModel: Newsitem?

    // MARK: - Setup

    private func setupView() {
        self.backgroundColor = .clear
        safeArea = layoutMarginsGuide
        setupNameLabel()
        setupDateLabel()
        setupAuthorLabel()
        setupTitleLabel()

    }

    private func setupNameLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textAlignment = .left
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 1
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (constraints) in
            constraints.top.equalToSuperview().offset(5)
            constraints.leading.equalToSuperview().offset(20)
        }
    }
    private func setupDateLabel() {
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textAlignment = .left
        dateLabel.textColor = .white
        dateLabel.numberOfLines = 1
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { constraints in
            constraints.centerY.equalTo(nameLabel.snp.centerY)
            constraints.trailing.equalToSuperview().offset(-10)
        }
    }
    private func setupAuthorLabel() {
        authorLabel.font = UIFont.italicSystemFont(ofSize: 12)
        authorLabel.textAlignment = .left
        authorLabel.textColor = .white
        authorLabel.numberOfLines = 1
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { (constraints) in
            constraints.top.equalTo(nameLabel.snp.bottom).offset(10)
            constraints.leading.equalToSuperview().offset(20)
        }
    }
    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { constraints in
            constraints.top.equalTo(authorLabel.snp.bottom).offset(12)
            constraints.leading.equalToSuperview().offset(20)
            constraints.trailing.equalToSuperview().offset(-10)
            constraints.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func getString(from date: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "d MMM, yyyy"
        let date = dateFormater.string(from: date)
        return date
    }

    func setupModel(model: Newsitem, name: String) {
        self.cellViewModel = model
        self.nameLabel.text = name
        self.titleLabel.text = model.title
        self.authorLabel.text = "by \(model.author.isEmpty ? "Unknown" : model.author)"
        let date = Date(timeIntervalSince1970: Double(model.date))
        self.dateLabel.text = getString(from: date)
        //        self.dateLabel.text = String(Date(timeIntervalSince1970: Double(model.date)))
    }

}
