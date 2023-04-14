//
//  ImageSaver.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/14/23.
//

import UIKit

class ImageSaver: NSObject {
  
  var completion: (() -> Void)?

  func writeToPhotoAlbum(image: UIImage) {
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
  }
  
  @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    completion?()
  }
  
  func addCompletion(completion: (() -> Void)? ) {
      self.completion = completion
  }
  
}
