//
//  GameListViewController.swift
//  SteamList
//
//  Created by Adam Bokun on 17.11.21.
//

import UIKit

class GameListViewController: UIViewController {
    private let listView = GameListView()
    var safeArea: UILayoutGuide!
    var gamesStorage = [Games]()
    var dataSource = [Games]()
    let child = SpinnerViewController()
    
    var gamesManager: GamesManagerProtocol
    let storageManager: StoreManagerProtocol
    let networkManager: NetworkManagerProtocol
    
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
        view = listView
    }
    
    func loadEventsPage() {
        gamesManager.getGames(endPoint: .getGamesList) { result in
            switch result {
            case .success(let games):
                DispatchQueue.main.async {
                    self.removeSpinnerView()
                }
                let games = games.applist.apps
                for game in games {
                    if !game.name.isEmpty {
                        self.dataSource.append(game)
                        self.gamesStorage.append(game)
                    }
                }
                self.storageManager.prepare(dataForSaving: self.dataSource)
                self.reloadTableView()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listView.update(state: GameListState(title: "Games", color: .white))
        let gamesList = storageManager.fetchAllData()
        if gamesList.isEmpty {
            DispatchQueue.main.async {
                self.createSpinnerView()
            }
            loadEventsPage()
        } else {
            dataSource = gamesList
            gamesStorage = gamesList
            DispatchQueue.main.async {
                self.reloadTableView()
                self.filterDataBySearchRequest()
            }
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        safeArea = view.layoutMarginsGuide
        setupView()
        listView.searchBar.delegate = self
        listView.tableView.dataSource = self
        listView.tableView.delegate = self
        listView.tableView.register(GameCell.self, forCellReuseIdentifier: "cellId")
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
    
    // MARK: - Setup View
    
    func setupView() {
        listView.searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top)
        }
        listView.endEditing(true)
    }
}

extension GameListViewController: UITableViewDelegate {}

extension GameListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GameCell()
        cell.setupModel(model: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Tapped")
        let detailController = DetailGameViewController(games: gamesManager,
                                                        storage: storageManager,
                                                        network: networkManager,
                                                        appId: self.dataSource[indexPath.row].appid,
                                                        name: dataSource[indexPath.row].name, isFavorite: dataSource[indexPath.row].isFavorite)
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.listView.tableView.reloadData()
        }
    }
}

extension GameListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.dataSource = gamesStorage
        reloadTableView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterDataBySearchRequest()
    }
    
    private func filterDataBySearchRequest() {
        guard let searchText = self.listView.searchBar.searchTextField.text else { return }
        if !searchText.isEmpty {
            self.dataSource = gamesStorage.filter({ game -> Bool in
                return game.name.lowercased().contains(searchText.lowercased())
            })
            self.reloadTableView()
        } else {
            self.dataSource = gamesStorage
            reloadTableView()
        }
    }
}
