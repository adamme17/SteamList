//
//  GameViewController.swift
//  SteamList
//
//  Created by Adam Bokun on 17.11.21.
//

import UIKit

class GameViewController: UIViewController {
    
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var someList = [Games]()
    
    let gamesManager = GamesManager()

    var pageId = 1

    func loadEventsPage (pageId: Int) {
        gamesManager.getGames() { result in
            switch result {
            case .success(let events):
                self.pageId += 1
                let events = events
//                if events.isEmpty {
//                    self.loadEventsPage(pageId: pageId+1)
//                }

//                self.storageManager.prepare(dataForSaving: events)

                for event in events {
                    self.someList.append(event)
                    //self.someList.append(event.actor.login)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
//       someList.append(contentsOf: storageManager.fetchAllData())
//       loadEventsPage(pageId: pageId)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
//        tableView.dataSource = self
//        tableView.delegate = self
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cellId")
        
        setupView()
    }
    
    // MARK: - Setup View
    
    func setupView() {
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
}
