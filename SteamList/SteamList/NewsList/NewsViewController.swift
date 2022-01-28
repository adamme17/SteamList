//
//  NewsViewController.swift
//  SteamList
//
//  Created by Adam Bokun on 17.11.21.
//

import UIKit

class NewsViewController: UIViewController {
    
    private let newsList = NewsView()
    private let filterViewController = FilterViewController()
    var safeArea: UILayoutGuide!
    private var newsModel = [Newsitem]()
    private var favorites = [FavoriteGames]()
    let child = SpinnerViewController()
    
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
            guard let self = self else { return }
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.removeSpinnerView()
                }
                self.newsModel += model["appnews"]?.newsitems ?? []
                self.newsModel = self.sortNewsByDate(news:  self.newsModel)
                self.filterViewController.newsModel.filteredNews = self.newsModel
                DispatchQueue.main.async {
                    self.newsList.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func sortNewsByDate(news: [Newsitem]) -> [Newsitem] {
        return news.sorted { (lhs, rhs) -> Bool in
            let lhsDate = Date(timeIntervalSince1970: Double(lhs.date))
            let rhsDate = Date(timeIntervalSince1970: Double(rhs.date))
            
            return lhsDate > rhsDate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newsList.update(state: NewsListState(title: "News", color: .white))
        
        let completionOperation = BlockOperation {
            DispatchQueue.main.async {
                self.newsList.tableView.reloadData()
            }
            
            self.filterViewController.newsModel.filteredGames = self.favorites.map {
                FilterItem(gameID: String($0.id),
                           name: $0.name ?? "",
                           isEnabled: false)
            }
        }
        
        favorites = storageManager.fetchFavoritesGamesToModel()
        
        if newsModel.isEmpty {
            for fav in favorites {
                DispatchQueue.main.async {
                    self.createSpinnerView()
                }
                let loadOperation = BlockOperation  {
                    self.loadNewsPage(appId: Int(fav.id))
                }
                completionOperation.addDependency(loadOperation)
                newsOperationQueue.addOperation(loadOperation)
            }
        }
        
        newsOperationQueue.addOperation(completionOperation)
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
        
        newsList.filterView.tableView.delegate = filterViewController
        newsList.filterView.tableView.dataSource = filterViewController
        newsList.filterView.saveButton.addTarget(self, action: #selector(saveFilterSettings), for: .touchUpInside)
        
        newsOperationQueue.maxConcurrentOperationCount = 5
        newsOperationQueue.qualityOfService = .utility
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
    
    @objc
    private func saveFilterSettings() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        UIView.animate(withDuration: 0.5) {
            self.newsList.blurView.alpha = 0
            self.newsList.topFilterViewConstraint?.update(offset: self.newsList.frame.height)
            self.newsList.layoutIfNeeded()
        } completion: { _ in
            self.newsList.deleteBlur()
            self.newsList.filterView.removeFromSuperview()
        }
        var gamesID = [String]()
        for game in filterViewController.newsModel.filteredGames where game.isEnabled {
            gamesID.append(game.gameID)
        }
        guard !gamesID.isEmpty else {
            newsModel = filterViewController.newsModel.filteredNews
            newsList.tableView.reloadData()
            return
        }
        newsModel = filterViewController.newsModel.filteredNews.filter { gamesID.contains(String($0.appid)) }
        newsList.tableView.reloadData()
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
            let yPoint = self.newsList.frame.height / 2 - self.newsList.filterView.frame.height / 2
            self.newsList.topFilterViewConstraint?.update(offset: yPoint)
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
        let favName = favorites.first(where: { $0.id == newsModel[indexPath.row].appid })?.name ?? ""
        print("Tapped")
        let detailNewsController = DetailNewsViewController(games: gamesManager,
                                                            storage: storageManager,
                                                            network: networkManager,
                                                            appId: self.newsModel[indexPath.row].appid,
                                                            title: self.newsModel[indexPath.row].title,
                                                            name: favName,
                                                            news: newsModel[indexPath.row])
        self.navigationController?.pushViewController(detailNewsController, animated: true)
    }
}
