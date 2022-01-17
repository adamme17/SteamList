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
    var news: Newsitem?
    let appId: Int
    let gameTitle: String
    let gameName: String
    var safeArea: UILayoutGuide!
    var gamesManager: GamesManagerProtocol
    let storageManager: StoreManagerProtocol
    let networkManager: NetworkManagerProtocol
    
    var newsID: String!

    init (games: GamesManagerProtocol, storage: StoreManagerProtocol, network: NetworkManagerProtocol, appId: Int, title: String, name: String, news: Newsitem) {
        self.gamesManager = games
        self.storageManager = storage
        self.networkManager = network
        self.appId = appId
        self.gameTitle = title
        self.gameName = name
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = detailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = gameTitle
        detailView.setupData(news: news!, appId: String(appId), gameName: gameName)
    }

    override func viewDidLoad() {
        safeArea = view.layoutMarginsGuide
        super.viewDidLoad()
        detailView.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*100)
    }
}
