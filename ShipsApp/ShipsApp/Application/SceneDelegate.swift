//
//  SceneDelegate.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 17/12/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let loginViewController = LoginViewController()
        window.rootViewController = UINavigationController(rootViewController: loginViewController)
        window.makeKeyAndVisible()
        self.window = window
    }
}
