//
//  Coordinator.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/14/23.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
