//
//  SceneDelegate.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/12/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var coordinator: PhotoCoordinator?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    let navigationController = UINavigationController()
    
    coordinator = PhotoCoordinator(navigationController: navigationController)
    coordinator?.start()
    
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }

}

