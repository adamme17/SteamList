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
    var favoriteButton = UIButton()
    
    var isFavotite: Bool = false {
        didSet {
            if isFavotite == false {
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped(sender: UIButton) {
          print("Button was tapped")
        isFavotite.toggle()
      }

    private var cellViewModel: Games?

    // MARK: - Setup

    private func setupView() {
        self.backgroundColor = .clear
        safeArea = layoutMarginsGuide
        setupNameLabel()
        setupFavouriteButton()
    }

    private func setupNameLabel() {
        nameLabel.textColor = .white
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (constraints) in
            constraints.top.equalToSuperview().offset(10)
            constraints.centerY.equalToSuperview()
            constraints.leading.equalToSuperview().offset(15)
        }
    }

    private func setupFavouriteButton() {
        contentView.addSubview(favoriteButton)
        if isFavotite == false {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        favoriteButton.tintColor = .orange
        favoriteButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        favoriteButton.clipsToBounds = true
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
        self.isFavotite = model.isFavorite
    }
}
