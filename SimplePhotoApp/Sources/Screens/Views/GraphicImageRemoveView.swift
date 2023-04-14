//
//  GraphicImageRemoveView.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/14/23.
//

import UIKit

class GraphicImageRemoveView: UIImageView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupViews()
  }
  
  private func setupViews() {
    self.isUserInteractionEnabled = true
    self.layer.borderColor = UIColor.systemPink.cgColor
    self.layer.borderWidth = 2.0
    self.layer.cornerRadius = 5.0
    self.image = UIImage(systemName: "xmark.circle.fill")
    self.backgroundColor = .white
    self.tintColor = .systemPink
    self.layer.cornerRadius = self.frame.width/2
    self.clipsToBounds = true
    self.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
  }
  
}



