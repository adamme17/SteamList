//
//  SceneDelegate.swift
//  SteamList
//
//  Created by Adam Bokun on 15.11.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        let rootViewController = ViewController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}

