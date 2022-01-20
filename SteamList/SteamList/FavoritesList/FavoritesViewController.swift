//
//  FavoritesViewController.swift
//  SteamList
//
//  Created by Adam Bokun on 17.11.21.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private let favList = FavoritesView()
    var safeArea: UILayoutGuide!
    var gamesStorage = [FavoriteGames]()
    var dataSource = [FavoriteGames]()
    var filteredFavoritesList = [FavoriteGames]()
    
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
        view = favList
    }

    override func viewWillAppear(_ animated: Bool) {
        favList.update(state: FavoritesListState(title: "Favorites", color: .white))
        let gamesList = storageManager.fetchFavoritesGamesToModel()
        
        dataSource = gamesList
        gamesStorage = gamesList
        DispatchQueue.main.async {
            self.reloadTableView()
            self.filterDataBySearchRequest()
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        safeArea = view.layoutMarginsGuide
        setupView()
        setupNavBar()
        favList.searchBar.delegate = self
        favList.tableView.dataSource = self
        favList.tableView.delegate = self
        favList.tableView.register(FavoritesCell.self, forCellReuseIdentifier: "cellId")
    }
    
    // MARK: - Setup View
    
    func setupView() {
        favList.searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top)
        }
        favList.endEditing(true)
    }
    
    private func setupNavBar() {
        let leftBarItem = UIBarButtonItem(title: "Sort",
                                          style: .plain,
                                          target: self,
                                          action: #selector(sortButtonPressed))
        let rightBarItem = UIBarButtonItem(title: "Edit",
                                           style: .plain,
                                           target: self,
                                           action: #selector(editButtonPressed))
        leftBarItem.tintColor = .white
        rightBarItem.tintColor = .white
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    @objc
    private func editButtonPressed() {
        favList.tableView.isEditing.toggle()
    }
    
    @objc
    private func sortButtonPressed() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Sort", preferredStyle: .actionSheet)
        
        let sortByNameAction = UIAlertAction(title: "Sort by name", style: .default) { _ in
            self.sortByName()
        }
        let sortByPriceAction = UIAlertAction(title: "Sort by price", style: .default) { _ in
            self.sortByPrice()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(sortByNameAction)
        optionMenu.addAction(sortByPriceAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    private func sortByName() {
        dataSource.sort { ($0.name?.lowercased() ?? "") < ($1.name?.lowercased() ?? "") }
        reloadTableView()
    }
    
    private func sortByPrice() {
        dataSource.sort { ($0.finalFormatted?.lowercased() ?? "") < ($1.finalFormatted?.lowercased() ?? "") }
        reloadTableView()
    }
}

extension FavoritesViewController: UITableViewDelegate {}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FavoritesCell()
        cell.setupModel(model: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.shared().deleteItemFromFavorites(id: indexPath.row)
            favList.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.favList.tableView.reloadData()
        }
    }
}

extension FavoritesViewController: UISearchBarDelegate {
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
        guard let searchText = self.favList.searchBar.searchTextField.text else { return }
        if !searchText.isEmpty {
            self.dataSource = gamesStorage.filter({ game -> Bool in
                return game.name?.lowercased().contains(searchText.lowercased()) ?? false
            })
            reloadTableView()
        } else {
            self.dataSource = gamesStorage
            reloadTableView()
        }
    }
}
