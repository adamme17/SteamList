//
//  FavoritesCell.swift
//  SteamList
//
//  Created by Adam Bokun on 28.12.21.
//

import UIKit
import SnapKit

class FavoritesCell: UITableViewCell {
    var safeArea: UILayoutGuide!
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let gamesNetworkManager = GamesManager(network: NetworkManager())
    
    private var appId = 0
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var cellViewModel: FavoriteGames?

    // MARK: - Setup

    private func setupView() {
        self.backgroundColor = .clear
        safeArea = layoutMarginsGuide
        setupNameLabel()
        setupPriceLabel()
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

    private func setupPriceLabel() {
        priceLabel.textColor = .white
        priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (constraints) in
            constraints.top.equalToSuperview().offset(10)
            constraints.centerY.equalTo(contentView)
            constraints.trailing.equalToSuperview().offset(-15)
            constraints.leading.greaterThanOrEqualTo(nameLabel.snp.trailing).offset(10)
        }
    }
    
    private func getGameData() {
        gamesNetworkManager.getGameDetails(endPoint: .getGameDetailsList(appId: appId)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let model = model[String(self.appId)] else {
                    return
                }
                if let gameData = model.data {
                    DispatchQueue.main.async {
                        self.priceLabel.text = gameData.priceOverview?.finalFormatted
                    }
                }
                if model.data?.isFree != true && model.data?.priceOverview?.discountPercent == 0 {
                    DispatchQueue.main.async {
                        self.priceLabel.text = model.data?.priceOverview?.finalFormatted
                    }
                } else {
                    DispatchQueue.main.async {
                        self.priceLabel.text = "Free"
                    }
                }
                if model.data?.isFree != true && model.data?.priceOverview?.discountPercent != 0 {
                    if let percent = model.data?.priceOverview?.discountPercent,
                       let price = model.data?.priceOverview?.finalFormatted {
                        DispatchQueue.main.async {
                            self.priceLabel.textColor = .green
                            self.priceLabel.text = "\(price) (-\(percent)%)"
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func setupModel(model: FavoriteGames) {
        self.cellViewModel = model
        self.nameLabel.text = model.name
//        self.priceLabel.text = model.finalFormatted
        self.appId = Int(model.id)
        
        getGameData()
    }
}
