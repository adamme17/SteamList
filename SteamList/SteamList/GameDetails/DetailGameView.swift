//
//  DetailGameView.swift
//  SteamList
//
//  Created by Adam Bokun on 7.12.21.
//

import UIKit
import SnapKit

final class DetailGameView: BackgroundView {
    
    let headerImage = CustomImageView()
    let nameLabel = UILabel()
    let genreLabel = UILabel()
    let typeLabel = UILabel()
    let priceLabel = UILabel()
    let releaseDateLabel = UILabel()
    let appleImage = UIImageView()
    let windowImage = UIImageView()
    let linuxImage = UIImageView()
    let isFavoriteButton = UIButton()
    let descrptionLabel = UILabel()
    let screenImage = UIImageView()
    
    override init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private func setupUI() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        self.addSubview(headerImage)
        self.addSubview(nameLabel)
        
        headerImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(nameLabel.snp.width).multipliedBy(0.5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.top.equalToSuperview().offset(20)
        }
    }
    
    func setupData(games: GameDetails) {
        if let url = URL(string: games.appId?.data?.headerImage ?? "") {
            headerImage.loadImage(from: url)
            nameLabel.text = games.appId?.data?.name
        }
    }
    func update(state: GameDetailState) {
        nameLabel.textColor = .white
        nameLabel.text = state.name
    }
}
struct GameDetailState {
    let name: String
    let color: UIColor
}
