//
//  AppDelegate.swift
//  SteamList
//
//  Created by Adam Bokun on 15.11.21.
//

import UIKit
import CoreData
import UserNotifications
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let gamesNetworkManager = GamesManager(network: NetworkManager())
    private var appId = 0
    let priceQueue = OperationQueue()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LocalNotification.shared.notificationCenter.delegate = self
        startUpdatingPrice()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
}

extension AppDelegate {

    private func startUpdatingPrice() {
        priceQueue.maxConcurrentOperationCount = 2
        priceQueue.qualityOfService = .background
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            let games = CoreDataManager.shared().fetchFavoritesGamesToModel()
            for game in games {
                self?.priceQueue.addOperation {
                    self?.checkPrice(game: game)
                }
            }
        }
    }

    private func checkPrice(game: FavoriteGames) {
        gamesNetworkManager.getGameDetails(endPoint: .getGameDetailsList(appId: Int(game.id))) { [unowned self] result in
                switch result {
                case .success(let model):
                    guard let model = model[String(game.id)] else {
                        return
                    }
                    if game.finalFormatted != model.data?.priceOverview?.finalFormatted {
                        LocalNotification.shared.sendNotification(
                            name: game.name!,
                            price: model.data?.priceOverview?.priceOverviewFinal ?? 0)
                        guard let model = model.data else { return }
                        CoreDataManager.shared().prepareFavorites(dataForSaving: [model])
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
