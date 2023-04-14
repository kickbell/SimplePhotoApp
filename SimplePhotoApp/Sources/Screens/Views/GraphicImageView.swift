//
//  GraphicImageView.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/14/23.
//

import UIKit

class GraphicImageView: UIImageView {
  
  init() {
    super.init(frame: .zero)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupViews()
  }
  
  private func setupViews() {
    self.isUserInteractionEnabled = true
    self.frame.size = CGSize(width: 150, height: 150)
    self.center = self.superview?.center ?? .zero
  }
  
}
