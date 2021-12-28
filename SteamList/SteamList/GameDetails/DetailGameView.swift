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
//    var contentStackView = UIStackView()
    
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
    
    private func setupUI() {
        setupConstraints()
        nameLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
//        contentView.addSubview(contentStackView)
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
        
        self.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        
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
        
        releaseDateLabel.textColor = .white
        releaseDateLabel.font = UIFont.systemFont(ofSize: 18)
        
        priceLabel.textColor = .systemGreen
        priceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        appleImage.tintColor = .white
        
        horizontalLine.backgroundColor = .gray
        
        descrptionLabel.numberOfLines = 0
        descrptionLabel.textColor = .white
        
//        contentStackView.axis = .horizontal
//        contentStackView.alignment = .fill
//        contentStackView.distribution = .fillProportionally
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.centerX.equalTo(scrollView)
        }
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
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(1)
        }
        descrptionLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalLine.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.greaterThanOrEqualTo(100)
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
                        make.top.equalTo(self.descrptionLabel.snp.bottom).offset(20)
                    }
                    make.leading.equalToSuperview().offset(10)
                    make.trailing.equalToSuperview().offset(-10)
                    make.height.equalTo(self.snp.width).multipliedBy(0.5)
                    if count == numbers - 1 {
                        make.bottom.equalToSuperview()
                    }
                }
                self.lastImageView = screenshotImageView
        }
        self.layoutIfNeeded()
        self.layoutSubviews()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*100)
    }
    
    func setupData(games: DetailResponse, appId: String) {
        self.appId = appId
        if let url = URL(string: games.data?.headerImage ?? "") {
            DispatchQueue.main.async {
                self.headerImage.loadImage(from: url)
                self.nameLabel.text = games.data?.name
                self.descrptionLabel.text = games.data?.shortDescript
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
        if (games.data?.releaseDate?.comingSoon == false) {
            DispatchQueue.main.async {
                self.releaseDateLabel.text = games.data?.releaseDate?.date
            }
        }
        if (games.data?.releaseDate?.comingSoon == true) {
            DispatchQueue.main.async {
                self.releaseDateLabel.text = "Coming soon"
                self.priceLabel.isHidden = true
            }
        }
        if (games.data?.isFree != true && games.data?.priceOverview?.discountPercent == 0) {
            DispatchQueue.main.async {
                self.priceLabel.text = games.data?.priceOverview?.finalFormatted
            }
        } else {
            DispatchQueue.main.async {
                self.priceLabel.text = "Free to Play"
            }
        }
        if (games.data?.isFree != true && games.data?.priceOverview?.discountPercent != 0) {
            if let percent = games.data?.priceOverview?.discountPercent,
               let price = games.data?.priceOverview?.finalFormatted {
                DispatchQueue.main.async {
                    self.priceLabel.text = "\(price) (-\(percent)%)"
                }
            }
        }
        if let mac = games.data?.platforms?.mac {
            DispatchQueue.main.async {
                self.appleImage.image = UIImage(named: "apple_icon")
                self.appleImage.contentMode = .scaleAspectFit
            }
        }
        if let windows = games.data?.platforms?.windows {
            DispatchQueue.main.async {
                self.windowsImage.image = UIImage(named: "windows_icon")
                self.windowsImage.contentMode = .scaleAspectFit
            }
        }
        if let linux = games.data?.platforms?.linux {
            DispatchQueue.main.async {
                self.linuxImage.image = UIImage(named: "linux_icon")
                self.linuxImage.contentMode = .scaleAspectFit
            }
        }
        
        if let screens = games.data?.screenshots {
            var screenUrl = ""
            DispatchQueue.main.async {
                self.setupScreenShotImageViews(numbers: screens.count)
                for (key, screens) in screens.enumerated() {
                    let imageView = self.screenshotsViews[key]
                    if let screenUrl = URL(string: screens.pathFull ?? "") {
                        DispatchQueue.main.async {
                            imageView.loadImage(from: screenUrl)
                        }
                    }
                }
            }
            
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
