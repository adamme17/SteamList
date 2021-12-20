//
//  DetailViewController.swift
//  SteamList
//
//  Created by Adam Bokun on 17.11.21.
//

import UIKit

class DetailGameViewController: UIViewController {
    var games: DetailResponse?
    var detailView = DetailGameView()
    let appId: Int
    let name: String
    let isFavorite: Bool
    var safeArea: UILayoutGuide!
    var gamesManager: GamesManagerProtocol
    let storageManager: StoreManagerProtocol
    let networkManager: NetworkManagerProtocol
    var gamesStorage = [Details]()
    var dataSource = [Details]()
    
    init (games: GamesManagerProtocol, storage: StoreManagerProtocol, network: NetworkManagerProtocol, appId: Int, name: String, isFavorite: Bool) {
        self.gamesManager = games
        self.storageManager = storage
        self.networkManager = network
        self.appId = appId
        self.name = name
        self.isFavorite = isFavorite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
    
    func loadEventsPage() {
        gamesManager.getGameDetails(endPoint: .getGameDetailsList(appId: appId)) { [unowned self] result in
            switch result {
            case .success(let model):
                guard let model = model[String(appId)] else {
                    return
                }
                self.games = model
                detailView.setupData(games: model, appId: String(appId))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = name
        let gamesList = storageManager.fetchAllData()
        if gamesList.isEmpty {
            loadEventsPage()
        } else {
//            dataSource += gamesList
//            gamesStorage += gamesList
        }
    }
    
    override func viewDidLoad() {
        safeArea = view.layoutMarginsGuide
        super.viewDidLoad()
        detailView.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*100)
//        detailView = DetailGameView()
//        setupUI()
        loadEventsPage()
    }
    
    func setupUI() {
        view.addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        detailView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        detailView.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*100)
    }
}


