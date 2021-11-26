//
//  GameListViewController.swift
//  SteamList
//
//  Created by Adam Bokun on 17.11.21.
//

import UIKit

class GameListViewController: UIViewController {

    private let listView = GameListView()
   
    let tableView = UITableView()
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
        listView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
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
