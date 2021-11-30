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
    var someList = [Games]()

    let gamesManager = GamesManager()
    
    override func loadView() {
        view = listView
    }

    func loadEventsPage() {
        gamesManager.getGames(endPoint: .getGamesList) { result in
            switch result {
            case .success(let games):
                let games = games.applist.apps

                for game in games {
                    if !game.name.isEmpty {
                        self.someList.append(game)
                    }
                }
                DispatchQueue.main.async {
                    self.listView.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        listView.update(state: GameListState(title: "Games", color: .black))
       loadEventsPage()
    }
    

    override func viewDidLoad() {
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupView()
        
//        navigationItem.searchBar = listView.searchBar
//        listView.searchBar.searchResultsUpdater = self
//        listView.searchController.searchResultsUpdate = self
        listView.searchBar.delegate = self
        listView.tableView.dataSource = self
        listView.tableView.delegate = self

        listView.tableView.register(GameCell.self, forCellReuseIdentifier: "cellId")
        refreshData()
    }
    func refreshData() {
//        let data =
//        let state = GameListState(title: data.title, color: data.color)
//        listView.updateState(state: state)
    }

//    // MARK: - Setup View

    func setupView() {
//        guard let navigationBar = self.navigationController?.navigationBar else {return}
//        listView.snp.makeConstraints { make in
//            make.edges.equalTo(safeArea)
//        }
        listView.searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top)
        }
        listView.endEditing(true)
    }
}

extension GameListViewController: UITableViewDelegate {

}

extension GameListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        someList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GameCell()
        cell.setupModel(model: someList[indexPath.row])
        return cell
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
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if !searchText.isEmpty {
                self.someList = someList.filter({ game -> Bool in
                    return game.name.lowercased().contains(searchText.lowercased())
                })
                self.listView.tableView.reloadData()
            }
}

//extension GameListViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//
//    }
}
