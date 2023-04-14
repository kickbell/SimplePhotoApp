//
//  UIView+Utils.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/14/23.
//

import UIKit

extension UIView {
  /**
   Convert UIView to UIImage
   */
  func toImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
    self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
    let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return snapshotImageFromMyView!
  }
}
