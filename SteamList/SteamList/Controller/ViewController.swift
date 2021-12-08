//
//  ViewController.swift
//  SteamList
//
//  Created by Adam Bokun on 15.11.21.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let network: NetworkManagerProtocol = NetworkManager()
        let games: GamesManagerProtocol = GamesManager(network: network)
        let store: StoreManagerProtocol = CoreDataManager()
        let gameVC = GameListViewController(games: games, storage: store, network: network)
        gameVC.navigationItem.title = "Games"
        let favoritesVC = FavoritesViewController()
        let newsVC = NewsViewController()

        title = "Games"

        gameVC.title = "Games"
        favoritesVC.title = "Favs"
        newsVC.title = "News"

        self.setViewControllers([gameVC, favoritesVC, newsVC], animated: true)

        guard let items = self.tabBar.items else { return }

        let images = ["list.star", "star.fill", "book.fill"]

        for item in 0...2 {
            items[item].image = UIImage(systemName: images[item])
        }
        self.tabBar.tintColor = .systemBlue
    }

}

extension ViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
        case is GameListViewController:
            title = "Games"
        case is FavoritesViewController:
            title = "Favorites"
        case is NewsViewController:
            title = "News"
        default:
            break
        }
    }
}
