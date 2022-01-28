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
        
        window.rootViewController = rootViewController
        window.tintColor = .white
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
        let favsNavController = UINavigationController(rootViewController: favoritesVC)
        favoritesVC.navigationItem.title = "Favorites"
        let newsVC = NewsViewController(games: games, storage: store, network: network)
        newsVC.navigationItem.title = "News"
        let newsNavController = UINavigationController(rootViewController: newsVC)
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = UIColor(red: 46, green: 100, blue: 133)
            appearance.shadowImage = UIImage()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        tabBarController.title = "Games"
        gameVC.title = "Games"
        favoritesVC.title = "Favs"
        newsVC.title = "News"

        tabBarController.setViewControllers([gamesNavController, favsNavController, newsNavController], animated: true)

        guard let items = tabBarController.tabBar.items else { return UINavigationController() }

        let images = ["list.star", "star.fill", "book.fill"]

        for item in 0...2 {
            items[item].image = UIImage(systemName: images[item])
        }
        tabBarController.tabBar.tintColor = .systemBlue
        tabBarController.tabBar.backgroundColor = .white
        
        return tabBarController
    }
}

extension SceneDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {}
}
