//
//  PhotoCoordinator.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/14/23.
//

import UIKit

final class PhotoCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  
  private var photoEditerViewController: PhotoEditerViewController!
    
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let photoListViewController = PhotoListViewController()
    photoListViewController.coordinator = self
    navigationController.pushViewController(photoListViewController, animated: true)
  }
  
  func didSelectPhoto(with image: UIImage?) {
    photoEditerViewController = PhotoEditerViewController(selectedImage: image)
    photoEditerViewController.coordinator = self
    photoEditerViewController.modalPresentationStyle = .overFullScreen
    
    navigationController.present(photoEditerViewController, animated: true)
  }
  
  func AddGraphicDidTap(on viewController: UIViewController) {
    let graphicViewController = GraphicViewController()
    graphicViewController.coordinator = self
    graphicViewController.modalPresentationStyle = .overFullScreen
    
    viewController.present(graphicViewController, animated: true)
  }
  
  func didSelectGraphic(with image: UIImage, on viewController: UIViewController) {
    photoEditerViewController.graphicImage = image
    
    viewController.dismiss(animated: true)
  }
}

