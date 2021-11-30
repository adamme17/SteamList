//
//  CustomCell.swift
//  SteamList
//
//  Created by Adam Bokun on 17.11.21.
//

import UIKit
import SnapKit

class GameCell: UITableViewCell {
    var safeArea: UILayoutGuide!
    let nameLabel = UILabel()
    let favoriteButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var cellViewModel: Games?

    // MARK: - Setup

    private func setupView() {
        safeArea = layoutMarginsGuide
        setupNameLabel()
        setupFavouriteButton()
    }

    private func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (constraints) in
            constraints.top.equalToSuperview().offset(10)
            constraints.centerY.equalToSuperview()
            constraints.leading.equalToSuperview().offset(15)
        }
    }
    
    private func setupFavouriteButton() {
        addSubview(favoriteButton)
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.tintColor = .orange
        favoriteButton.snp.makeConstraints { (constraints) in
            constraints.top.equalToSuperview().offset(10)
            constraints.centerY.equalTo(contentView)
            constraints.trailing.equalTo(contentView).offset(-15)
            constraints.leading.greaterThanOrEqualTo(nameLabel.snp.trailing).offset(10)
            constraints.width.greaterThanOrEqualTo(20)
        }
    }

    func setupModel(model: Games) {
        self.cellViewModel = model
        self.nameLabel.text = model.name
    }

}
