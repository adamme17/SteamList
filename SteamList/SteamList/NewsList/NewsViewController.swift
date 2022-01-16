//
//  NewsViewController.swift
//  SteamList
//
//  Created by Adam Bokun on 17.11.21.
//

import UIKit

class NewsViewController: UIViewController {

    private let newsList = NewsView()
    var safeArea: UILayoutGuide!
    private var newsModel = [Newsitem]()
    private var favorites = [FavoriteGames]()
    
    var gamesManager: GamesManagerProtocol
    let storageManager: StoreManagerProtocol
    let networkManager: NetworkManagerProtocol
    
    let newsOperationQueue = OperationQueue()
    
    init (games: GamesManagerProtocol, storage: StoreManagerProtocol, network: NetworkManagerProtocol) {
        self.gamesManager = games
        self.storageManager = storage
        self.networkManager = network
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = newsList
    }
    
    func loadNewsPage(appId: Int) {
        gamesManager.getGameNews(endPoint: .getGameNews(appId: appId, number: 10)) { [weak self] result in
            switch result {
            case .success(let model):
                self?.newsModel += model["appnews"]?.newsitems ?? []
                DispatchQueue.main.async {
                    self?.newsList.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newsList.update(state: NewsListState(title: "News", color: .white))
        favorites = storageManager.fetchFavoritesGamesToModel()
        for fav in favorites {
            newsOperationQueue.addOperation {
                self.loadNewsPage(appId: Int(fav.id))
            }
        }
    }
    
    private func setupNavBar() {
        let rightBarItem = UIBarButtonItem(title: "Filter",
                                           style: .plain,
                                           target: self,
                                           action: #selector(filterButtonPressed))
        rightBarItem.tintColor = .white
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        safeArea = view.layoutMarginsGuide
        setupNavBar()
        newsList.tableView.dataSource = self
        newsList.tableView.delegate = self
        newsList.tableView.register(NewsCell.self, forCellReuseIdentifier: "cellId")
        
        newsOperationQueue.maxConcurrentOperationCount = 5
        newsOperationQueue.qualityOfService = .utility
    }
    
    @objc
    private func filterButtonPressed() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        newsList.addBlur()
        UIView.animate(withDuration: 0.5) {
            self.newsList.blurView.alpha = 1
        }
        newsList.setupFilterView()
        UIView.animate(withDuration: 0.5) {
//            let yPoint = self.newsList.frame.height / 2 - self.newsList.filterView.frame.height / 2
//            self.newsList.topFilterViewConstraint?.update(offset: yPoint)
            self.newsList.layoutIfNeeded()
        }
    }
}

extension NewsViewController: UITableViewDelegate {}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NewsCell()
        let favName = favorites.first(where: { $0.id == newsModel[indexPath.row].appid })?.name ?? ""
        cell.setupModel(model: newsModel[indexPath.row], name: favName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Tapped")
        let detailNewsController = DetailNewsViewController(games: gamesManager,
                                                        storage: storageManager,
                                                        network: networkManager,
                                                            appId: self.newsModel[indexPath.row].appid,
                                                            title: self.newsModel[indexPath.row].title)
        self.navigationController?.pushViewController(detailNewsController, animated: true)
    }
}
