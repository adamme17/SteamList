//
//  DetailGameView.swift
//  SteamList
//
//  Created by Adam Bokun on 7.12.21.
//

import UIKit
import SnapKit

final class DetailGameView: BackgroundView {
    
    var appId = ""
    
    let headerImage = CustomImageView()
    let nameLabel = UILabel()
    let genreLabel = UILabel()
    let typeLabel = UILabel()
    let priceLabel = UILabel()
    let releaseDateLabel = UILabel()
    let appleImage = UIImageView()
    let windowImage = UIImageView()
    let linuxImage = UIImageView()
    var isFavoriteButton = UIButton()
    let descrptionLabel = UILabel()
    let screenImage = UIImageView()
    
    var isFavorite: Bool = false {
        didSet {
            if isFavorite == false {
                        let config = UIImage.SymbolConfiguration(
                            pointSize: 25, weight: .medium, scale: .default)
                        let image = UIImage(systemName: "star", withConfiguration: config)
                        isFavoriteButton.setImage(image, for: .normal)
            } else {
                let config = UIImage.SymbolConfiguration(
                    pointSize: 25, weight: .medium, scale: .default)
                let image = UIImage(systemName: "star.fill", withConfiguration: config)
                isFavoriteButton.setImage(image, for: .normal)
            }
        }
    }
    
    override init() {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped(sender: UIButton) {
        print("Button was tapped")
        isFavorite.toggle()
      }
    
    var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private func setupUI() {
        setupConstraints()
        nameLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        self.addSubview(headerImage)
        self.addSubview(nameLabel)
        self.addSubview(isFavoriteButton)
        self.addSubview(genreLabel)
        
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        nameLabel.numberOfLines = 2
        
        isFavoriteButton.tintColor = .orange
        isFavoriteButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        isFavoriteButton.clipsToBounds = true
        let config = UIImage.SymbolConfiguration(
            pointSize: 25, weight: .medium, scale: .default)
        let image = UIImage(systemName: "star", withConfiguration: config)
        isFavoriteButton.setImage(image, for: .normal)
        
        genreLabel.textColor = .white
        genreLabel.numberOfLines = 0
        genreLabel.textAlignment = .center
        
        headerImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.height.equalTo(nameLabel.snp.width).multipliedBy(0.5)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(35)
            make.top.equalTo(headerImage.snp.bottom).offset(10)
        }
        isFavoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
            make.top.equalTo(headerImage.snp.bottom).offset(10)
        }
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
    }
    
    func setupData(games: DetailResponse, appId: String) {
        self.appId = appId
        if let url = URL(string: games.data?.headerImage ?? "") {
            DispatchQueue.main.async {
                self.headerImage.loadImage(from: url)
                self.nameLabel.text = games.data?.name
//                self.genreLabel.text = games.data?.genres?.description
            }
        }
        if let genres = games.data?.genres {
            var genresString = ""
            for genre in genres {
                genresString += "\(genre.genreDescription ?? "")       "
            }
            DispatchQueue.main.async {
                self.genreLabel.text = genresString
            }
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
