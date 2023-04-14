//
//  GraphicImageBorderView.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/14/23.
//

import UIKit

class GraphicImageBorderView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupViews()
  }
  
  private func setupViews() {
    self.layer.borderColor = UIColor.systemPink.cgColor
    self.layer.borderWidth = 2.0
    self.layer.cornerRadius = 5.0
  }
  
}
