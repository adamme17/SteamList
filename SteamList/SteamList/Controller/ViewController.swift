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

        let gameVC = GameViewController()
        let favoritesVC = FavoritesViewController()
        let newsVC = NewsViewController()

        gameVC.title = "Games"
        favoritesVC.title = "Favs"
        newsVC.title = "News"

        self.setViewControllers([gameVC, favoritesVC, newsVC], animated: false)

        guard let items = self.tabBar.items else { return }

        let images = ["list.star", "star.fill", "book.fill"]

        for item in 0...2 {
            items[item].image = UIImage(systemName: images[item])
        }
        self.tabBar.tintColor = .systemBlue
    }

}
