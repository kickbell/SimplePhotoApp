//
//  GridCell.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/13/23.
//

import UIKit

class GridCell: UICollectionViewCell {
  
  // MARK: - Views

  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  // MARK: - ViewLifeCycles

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupViews()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.imageView.image = nil
  }
  
  // MARK: - Methods

  private func setupViews() {
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  func configure(with image: UIImage) {
    self.imageView.image = image
  }
  
}

