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
    var appleImage = UIImageView()
    var windowsImage = UIImageView()
    var linuxImage = UIImageView()
    var isFavoriteButton = UIButton()
    let descrptionLabel = UILabel()
    let screenImage = CustomImageView()
    let horizontalLine = UIView()
    var tappedScreenshotCompletion: ((UIImage) -> Void)!
    var screenshotsViews = [CustomImageView]()
    var lastImageView: UIImageView?
    var scrollView = UIScrollView()
    var contentView = UIView()
    let storageManager = CoreDataManager.shared()
    var games: Details?
    
    var isFavorite: Bool = false {
        didSet {
            if isFavorite == false {
                let config = UIImage.SymbolConfiguration(
                    pointSize: 25, weight: .medium, scale: .default)
                let image = UIImage(systemName: "star", withConfiguration: config)
                isFavoriteButton.setImage(image, for: .normal)
                guard let appId = Int(appId) else { return }
                storageManager.deleteItemFromFavorites(id: appId)
            } else {
                let config = UIImage.SymbolConfiguration(
                    pointSize: 25, weight: .medium, scale: .default)
                let image = UIImage(systemName: "star.fill", withConfiguration: config)
                DispatchQueue.main.async {
                    self.isFavoriteButton.setImage(image, for: .normal)
                }
                guard let games = games else {
                    return
                }
                storageManager.prepareFavorites(dataForSaving: [games])
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
    
    private func setupUI() {
        setupConstraints()
        nameLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        self.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.addSubview(contentView)
        contentView.addSubview(headerImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(isFavoriteButton)
        contentView.addSubview(genreLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(appleImage)
        contentView.addSubview(windowsImage)
        contentView.addSubview(linuxImage)
        contentView.addSubview(horizontalLine)
        contentView.addSubview(descrptionLabel)
        
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        nameLabel.numberOfLines = 0
        
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
        
        releaseDateLabel.textColor = .white
        releaseDateLabel.font = UIFont.systemFont(ofSize: 18)
        
        priceLabel.textColor = .systemGreen
        priceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        appleImage.tintColor = .white
        
        horizontalLine.backgroundColor = .gray
        
        descrptionLabel.numberOfLines = 0
        descrptionLabel.textColor = .white
        
        
        scrollView.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.width.equalToSuperview()
//            make.centerX.equalToSuperview()
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
//            make.top.bottom.equalTo(self.scrollView)
//            make.left.right.equalToSuperview()
//            make.width.equalTo(self.scrollView)
//            make.height.equalTo(self.scrollView)
            make.centerX.width.top.bottom.equalToSuperview()
        }
        headerImage.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView)
            //            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.top.equalToSuperview()
//            make.height.equalTo(200)
            make.height.equalTo(nameLabel.snp.width).multipliedBy(0.5)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
//            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(35)
            make.top.equalTo(headerImage.snp.bottom).offset(10)
        }
        isFavoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
//            make.height.equalTo(50)
            make.top.equalTo(headerImage.snp.bottom).offset(10)
        }
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        releaseDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.top.equalTo(genreLabel.snp.bottom).offset(10)
        }
        priceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(genreLabel.snp.bottom).offset(10)
        }
        linuxImage.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(20)
            make.height.equalTo(25)
            make.width.equalTo(25)
            make.trailing.equalToSuperview().inset(20)
        }
        windowsImage.snp.makeConstraints { make in
            make.centerY.equalTo(linuxImage)
            make.height.equalTo(25)
            make.width.equalTo(25)
            make.trailing.equalTo(linuxImage).inset(35)
        }
        appleImage.snp.makeConstraints { make in
            make.centerY.equalTo(linuxImage)
            make.height.equalTo(25)
            make.width.equalTo(25)
            make.trailing.equalTo(windowsImage).inset(35)
        }
        horizontalLine.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(15)
            make.leading.equalTo(contentView).offset(10)
            make.trailing.equalTo(contentView).offset(-10)
            make.height.equalTo(1)
        }
        descrptionLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalLine.snp.bottom).offset(20)
            make.leading.equalTo(contentView).offset(10)
            make.trailing.equalTo(contentView).offset(-10)
//            make.height.greaterThanOrEqualTo(100)
        }
    }
    
    func setupScreenShotImageViews(numbers: Int) {
        for count in 0..<numbers {
            let screenshotImageView = CustomImageView()
            screenshotImageView.translatesAutoresizingMaskIntoConstraints = false
            screenshotImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedScreenshot(handler:)))
            screenshotImageView.addGestureRecognizer(tapGesture)
            self.screenshotsViews.append(screenshotImageView)
            
            contentView.addSubview(screenshotImageView)
            screenshotImageView.snp.makeConstraints { make in
                if let lastImageView = self.lastImageView {
                    make.top.equalTo(lastImageView.snp.bottom).offset(5)
                } else {
                    make.top.equalTo(descrptionLabel.snp.bottom).offset(20)
                }
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-10)
                make.height.equalTo(self.snp.width).multipliedBy(0.5)
//                make.bottom.equalTo(contentView)
                if count == numbers - 1 {
                    make.bottom.equalTo(contentView)
                }
            }
            self.lastImageView = screenshotImageView
        }
    }
    
    private var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .white
        return errorLabel
    }()
    
    private func setupErrorLabel(text: String) {
        DispatchQueue.main.async {
            self.addSubview(self.errorLabel)
            self.errorLabel.text = text
        
            self.horizontalLine.isHidden = true
            self.isFavoriteButton.isHidden = true
            
            self.errorLabel.snp.makeConstraints { constraints in
                constraints.center.equalToSuperview()
            }
        }
    }
    
    func failureSetupData() {
        setupErrorLabel(text: "Oops... No data here")
    }
    
    func setupData(games: Details, appId: String) {
        if games.name?.isEmpty == false {
            succesSetupData(games: games, appId: appId)
        } else {
            setupErrorLabel(text: "Oops... No data here")
        }
    }
    
    func succesSetupData(games: Details, appId: String) {
        self.appId = appId
        self.games = games
        if let url = URL(string: games.headerImage ?? "") {
            DispatchQueue.main.async {
                self.headerImage.loadImage(from: url)
            }
        }
        DispatchQueue.main.async {
            self.nameLabel.text = games.name
            self.descrptionLabel.text = games.shortDescript
        }
        if let genres = games.genres {
            if genres.isEmpty {
                genreLabel.isHidden = true
            } else {
                var genresString = ""
                for genre in genres {
                    genresString += "\(genre.genreDescription ?? "")       "
                }
                DispatchQueue.main.async {
                    self.genreLabel.text = genresString
                }
            }
        }
        if (games.releaseDate?.comingSoon == false) {
            DispatchQueue.main.async {
                self.releaseDateLabel.text = games.releaseDate?.date
            }
        }
        if (games.releaseDate?.comingSoon == true) {
            DispatchQueue.main.async {
                self.releaseDateLabel.text = "Coming soon"
                self.priceLabel.isHidden = true
            }
        }
        if (games.isFree != true && games.priceOverview?.discountPercent == 0) {
            DispatchQueue.main.async {
                self.priceLabel.text = games.priceOverview?.finalFormatted
            }
        } else {
            DispatchQueue.main.async {
                self.priceLabel.text = "Free to Play"
            }
        }
        if (games.isFree != true && games.priceOverview?.discountPercent != 0) {
            if let percent = games.priceOverview?.discountPercent,
               let price = games.priceOverview?.finalFormatted {
                DispatchQueue.main.async {
                    self.priceLabel.text = "\(price) (-\(percent)%)"
                }
            }
        }
        if let mac = games.platforms?.mac {
            DispatchQueue.main.async {
                self.appleImage.image = UIImage(named: "apple_icon")
                self.appleImage.contentMode = .scaleAspectFit
            }
        }
        if let windows = games.platforms?.windows {
            DispatchQueue.main.async {
                self.windowsImage.image = UIImage(named: "windows_icon")
                self.windowsImage.contentMode = .scaleAspectFit
            }
        }
        if let linux = games.platforms?.linux {
            DispatchQueue.main.async {
                self.linuxImage.image = UIImage(named: "linux_icon")
                self.linuxImage.contentMode = .scaleAspectFit
            }
        }
        
        if let screens = games.screenshots {
            var screenUrl = ""
            DispatchQueue.main.async {
                self.setupScreenShotImageViews(numbers: screens.count)
                for (key, screens) in screens.enumerated() {
                    let imageView = self.screenshotsViews[key]
                    if let screenUrl = URL(string: screens.pathFull ?? "") {
                        imageView.loadImage(from: screenUrl)
                    }
                }
            }
        }
        let favorites = storageManager.fetchFavoritesGames()
        
        if favorites.contains(where: { $0 == games.steamAppid }) {
            isFavorite = true
        }
    }
    func update(state: GameDetailState) {
        nameLabel.textColor = .white
        nameLabel.text = state.name
    }
    @objc private func tappedScreenshot(handler: UITapGestureRecognizer) {
        if let imageView = handler.view as? UIImageView,
           let image = imageView.image {
            tappedScreenshotCompletion(image)
        }
    }
}
struct GameDetailState {
    let name: String
    let color: UIColor
}
