//
//  SceneDelegate.swift
//  SteamList
//
//  Created by Adam Bokun on 15.11.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let tabBarController = UITabBarController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)
        let rootViewController = viewController()
//        rootViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }

    func viewController() -> UIViewController {
        let network: NetworkManagerProtocol = NetworkManager()
        let games: GamesManagerProtocol = GamesManager(network: network)
        let store: StoreManagerProtocol = CoreDataManager.shared()
        let gameVC = GameListViewController(games: games, storage: store, network: network)
        gameVC.navigationItem.title = "Games"
        let gamesNavController = UINavigationController(rootViewController: gameVC)
        gamesNavController.navigationBar.barTintColor = UIColor(red: 48, green: 100, blue: 133)
        let favoritesVC = FavoritesViewController(games: games, storage: store, network: network)
        let newsVC = NewsViewController()
        
        tabBarController.title = "Games"
        tabBarController.delegate = self

        gameVC.title = "Games"
        //gameVC.navigationItem.titleView.t titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        favoritesVC.title = "Favs"
        newsVC.title = "News"

        tabBarController.setViewControllers([gamesNavController, favoritesVC, newsVC], animated: true)

        guard let items = tabBarController.tabBar.items else { return UINavigationController() }

        let images = ["list.star", "star.fill", "book.fill"]

        for item in 0...2 {
            items[item].image = UIImage(systemName: images[item])
        }
        tabBarController.tabBar.tintColor = .systemBlue
        
        return tabBarController
    }
}

extension SceneDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        switch viewController {
//        case is GameListViewController:
//            tabBarController.title = "Games"
//        case is FavoritesViewController:
//            tabBarController.title = "Favorites"
//        case is NewsViewController:
//           // tabBarController.title = "News"
//        default:
//            break
//        }
    }
}
