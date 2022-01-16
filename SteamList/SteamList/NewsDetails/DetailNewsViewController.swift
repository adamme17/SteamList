//
//  DetailNewsViewController.swift
//  SteamList
//
//  Created by Adam Bokun on 17.11.21.
//

import UIKit

class DetailNewsViewController: UIViewController {
    var detailView = DetailNewsView()
    private var newsModel = [Newsitem]()
    let appId: Int
    let gameTitle: String
    var safeArea: UILayoutGuide!
    var gamesManager: GamesManagerProtocol
    let storageManager: StoreManagerProtocol
    let networkManager: NetworkManagerProtocol
    
    var newsID: String!

    init (games: GamesManagerProtocol, storage: StoreManagerProtocol, network: NetworkManagerProtocol, appId: Int, title: String) {
        self.gamesManager = games
        self.storageManager = storage
        self.networkManager = network
        self.appId = appId
        self.gameTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetailNewsPage(appId: appId)
    }
    
    func loadDetailNewsPage(appId: Int) {
        gamesManager.getGameNews(endPoint: .getGameNews(appId: appId, number: 10)) { [weak self] result in
            switch result {
            case .success(let model):
                self?.newsModel += model["appnews"]?.newsitems ?? []
                DispatchQueue.main.async {
                    self?.updateView()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func updateView() {
        var model: Newsitem?
        detailView.authorLabel.text = "by \(model?.author)"
        detailView.dateLabel.text = "30 Oct, 2021"//CustomDateFormater.shared.getString(from: newsInfo.date)
        detailView.titleLabel.text = model?.title
        detailView.gameNameLabel.text = "Game 1" //newsInfo.gameName
        let font = UIFont.systemFont(ofSize: 40)
        let fontName =  "-apple-system"
        let linkStyle = "<style>a:link { color: \(UIColor.init(red: 122, green: 144, blue: 200, alpha: 100)); }</style>"
        let htmlString = "\(linkStyle)<span style=\"font-family: \(fontName); font-size: \(font.pointSize); color: #FFFFFF\">\(model?.contents)</span>"
        detailView.webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
}
