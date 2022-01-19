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
    let child = SpinnerViewController()
    
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
                
                DispatchQueue.main.async {
                    removeSpinnerView()
                }
                
                guard let model = model[String(appId)] else {
                    return
                }
                self.games = model
                if model.success == false {
                    detailView.failureSetupData()
                }
                if let gameData = model.data {
                    coreDataManager.prepareDetails(dataForSaving: [gameData])
                    detailView.setupData(games: gameData, appId: String(appId))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    removeSpinnerView()
                }
                
                detailView.failureSetupData()
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = name
        let group = DispatchGroup()
        var game: Details?
        DispatchQueue.main.async(group: group) { [self] in
            game = storageManager.fetchGameDetail(id: self.appId)
        }
        group.notify(queue: .main) { [self] in
            if game == nil {
                DispatchQueue.main.async {
                    createSpinnerView()
                }
                loadDetailsPage()
            } else {
                detailView.setupData(games: game!, appId: String(appId))
            }
        }
    }
    
    override func viewDidLoad() {
        safeArea = view.layoutMarginsGuide
        super.viewDidLoad()
        setupScreenshots()
        detailView.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*100)
    }
    
    func createSpinnerView() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeSpinnerView() {
        self.child.willMove(toParent: nil)
        self.child.view.removeFromSuperview()
        self.child.removeFromParent()
    }
    
    private func setupScreenshots() {
        detailView.tappedScreenshotCompletion = { [weak self] image in
            let screenshotController = ScreenshotViewController()
            screenshotController.image = image
            self?.navigationController?.pushViewController(screenshotController, animated: true)
        }
    }
    
    func setupUI() {
        view.addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        detailView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}
