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
    let coreDataManager = CoreDataManager.shared()
    
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
    
    func loadDetailsPage() {
        gamesManager.getGameDetails(endPoint: .getGameDetailsList(appId: appId)) { [unowned self] result in
            switch result {
            case .success(let model):
                guard let model = model[String(appId)] else {
                    return
                }
                self.games = model
                if let gameData = model.data {
                    coreDataManager.prepareDetails(dataForSaving: [gameData])
                    detailView.setupData(games: gameData, appId: String(appId))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = name
        let group = DispatchGroup()
        var gamesList = [Details]()
        DispatchQueue.main.async(group: group) { [self] in
            gamesList += storageManager.fetchGameDetail(id: self.appId)
        }
        group.notify(queue: .main) { [self] in
//            if gamesList.isEmpty {
                loadDetailsPage()
//            } else {
//                guard let game = gamesList.first(where: {$0.steamAppid == self.appId}) else {return}
//                detailView.setupData(games: game, appId: String(appId))
//            }
        }
    }
    
    override func viewDidLoad() {
        safeArea = view.layoutMarginsGuide
        super.viewDidLoad()
        detailView.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*100)
    }
    
    func setupUI() {
        view.addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        detailView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        detailView.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*100)
    }
}


