//
//  DetailViewController.swift
//  SteamList
//
//  Created by Adam Bokun on 17.11.21.
//

import UIKit

class DetailGameViewController: UIViewController {
    var games: GameDetails?
    var detailView: DetailGameView?
    let appId: Int
    
    var safeArea: UILayoutGuide!
    
    var gamesManager: GamesManagerProtocol
    let storageManager: StoreManagerProtocol
    let networkManager: NetworkManagerProtocol
    
    init (games: GamesManagerProtocol, storage: StoreManagerProtocol, network: NetworkManagerProtocol, appId: Int) {
        self.gamesManager = games
        self.storageManager = storage
        self.networkManager = network
        self.appId = appId
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
                self.games = model
                detailView?.setupData(games: model)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        detailView?.update(state: GameDetailState(name: "name of app", color: .white))
        let gamesList = storageManager.fetchAllData()
        //        if gamesList.isEmpty {
        loadEventsPage()
        //        } else {
        //            dataSource += gamesList
        //            gamesStorage += gamesList
        //        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        safeArea = view.layoutMarginsGuide
        super.viewDidLoad()
        detailView = DetailGameView()
        setupUI()
        loadEventsPage()
    }
    
    func setupUI() {
        guard let detailView = detailView else { return }
        view.addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        detailView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}


