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
        window.rootViewController = viewController()
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func viewController() -> UINavigationController {
        return UINavigationController(rootViewController: ViewController())
    }
}

