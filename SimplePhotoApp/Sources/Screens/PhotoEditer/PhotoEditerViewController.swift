//
//  DetailViewController.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/13/23.
//

import UIKit

class PhotoEditerViewController: UIViewController {
  
  // MARK: - Views
  
  private lazy var closeButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(
      systemName: "xmark.circle",
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
    button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
    button.tintColor = .label
    return button
  }()
  
  private lazy var canvasImageView: UIImageView = {
    let imageView = UIImageView()
    let hiddenGesture = UITapGestureRecognizer(target: self, action: #selector(self.hiddenBorderToggle(sender:)))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = .lightGray
    imageView.image = selectedImage
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(hiddenGesture)
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let toolBarStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  // MARK: - Properties
  
  var selectedImage: UIImage?
  
  var graphicImage: UIImage? {
    didSet {
      updateUI()
    }
  }
  
  weak var coordinator: PhotoCoordinator?
  
  // MARK: - ViewLifeCycles
  
  init(selectedImage: UIImage? = nil, graphicImage: UIImage? = nil) {
    self.selectedImage = selectedImage
    self.graphicImage = graphicImage
    super.init(nibName: nil, bundle: nil)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    self.selectedImage = nil
    self.graphicImage = nil
    super.init(coder: coder)
    
    setupViews()
  }
  
}

// MARK: - Methods

extension PhotoEditerViewController {
  
  @objc
  private func closeButtonDidTap(sender: UIButton) {
    dismiss(animated: true)
  }
  
  private func updateUI() {
    let graphicImageView = GraphicImageView()
    graphicImageView.center = canvasImageView.center
    graphicImageView.image = self.graphicImage
    
    let graphicImageBorderView = GraphicImageBorderView(frame: graphicImageView.bounds)
    
    let graphicImageRemoveView = GraphicImageRemoveView(frame: CGRect(x: graphicImageView.frame.width - 35, y: 5, width: 30, height: 30))
    let removeGestrue = UITapGestureRecognizer(target: self, action: #selector(self.removeFromCanvasImageView(sender:)))
    
    canvasImageView.addSubview(graphicImageView)
    graphicImageView.addSubview(graphicImageBorderView)
    graphicImageView.addSubview(graphicImageRemoveView)
    graphicImageRemoveView.addGestureRecognizer(removeGestrue)
    
    addGestures(view: graphicImageView)
  }
  
  private func setupViews() {
    view.backgroundColor = .systemBackground
    view.addSubview(canvasImageView)
    view.addSubview(closeButton)
    view.addSubview(toolBarStackView)
    
    addToolBar()
    
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      
      canvasImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
      canvasImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      canvasImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      canvasImageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.7),
      
      toolBarStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      toolBarStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      toolBarStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
    ])
  }
  
  private func addToolBar() {
    ["camera.filters",
     "photo.artframe",
     "textformat",
     "square.and.arrow.down"].enumerated().forEach { idx, str in
      let button = UIButton()
      button.setImage(UIImage(
        systemName: str,
        withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
      button.tag = idx
      button.addTarget(self, action: #selector(toolBarButtonDidTap), for: .touchUpInside)
      button.tintColor = .label
      
      toolBarStackView.addArrangedSubview(button)
    }
  }
  
  @objc
  private func toolBarButtonDidTap(sender: UIButton) {
    switch sender.tag {
    case 1:
      coordinator?.AddGraphicDidTap(on: self)
    case 3:
      let imageSaver = ImageSaver()
      imageSaver.writeToPhotoAlbum(image: canvasImageView.toImage())
      imageSaver.completion = { self.alert(message: "사진 앨범에 이미지 저장이 완료되었습니다.") }
    default:
      self.alert(message: "지원되지 않는 기능입니다.")
    }
  }
  
  @objc
  private func removeFromCanvasImageView(sender: UITapGestureRecognizer) {
    sender.view?.superview?.removeFromSuperview()
  }
  
  @objc
  private func hiddenBorderToggle(sender: UITapGestureRecognizer) {
    sender.view?.subviews.forEach {
      $0.subviews.forEach {
        $0.isHidden = true
      }
    }
  }
  
  private func addGestures(view: UIView) {
    view.isUserInteractionEnabled = true
    
    let panGesture = UIPanGestureRecognizer(target: self,
                                            action: #selector(panGesture))
    panGesture.minimumNumberOfTouches = 1
    panGesture.maximumNumberOfTouches = 1
    panGesture.delegate = self
    view.addGestureRecognizer(panGesture)
    
    let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                action: #selector(pinchGesture))
    pinchGesture.delegate = self
    view.addGestureRecognizer(pinchGesture)
    
    let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self,
                                                                action:#selector(rotationGesture) )
    rotationGestureRecognizer.delegate = self
    view.addGestureRecognizer(rotationGestureRecognizer)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
    view.addGestureRecognizer(tapGesture)
  }
  
  
}

// MARK: - UIGestureRecognizerDelegate

extension PhotoEditerViewController: UIGestureRecognizerDelegate {
  
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }
  
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }
  
}

// MARK: - UIGestureActions

extension PhotoEditerViewController {
  
  @objc
  private func panGesture(sender: UIPanGestureRecognizer) {
    guard let panView = sender.view else { return }
    let translation = sender.translation(in: canvasImageView)
    let changedX = panView.center.x + translation.x
    let changedY = panView.center.y + translation.y
    
    panView.center = CGPoint(x: changedX, y: changedY)
    sender.setTranslation(.zero, in: panView)
  }
  
  @objc
  private func pinchGesture(sender: UIPinchGestureRecognizer) {
    guard let pinchView = sender.view else { return }
    pinchView.transform = pinchView.transform.scaledBy(x: sender.scale, y: sender.scale)
    sender.scale = 1.0
  }
  
  @objc
  private func rotationGesture(sender: UIRotationGestureRecognizer) {
    guard let rotationView = sender.view else { return }
    rotationView.transform = rotationView.transform.rotated(by: sender.rotation)
    sender.rotation = 0
  }
  
  @objc
  private func tapGesture(sender: UITapGestureRecognizer) {
    toggleEffect(sender)
    transformEffect(sender)
  }
  
  private func toggleEffect(_ sender: UITapGestureRecognizer) {
    sender.view?.superview?.subviews.forEach {
      $0.subviews.forEach {
        $0.isHidden.toggle()
      }
    }
  }
  
  private func transformEffect(_ sender: UITapGestureRecognizer) {
    guard let tapView = sender.view else { return }
    let previouTransform = tapView.transform
    
    UIView.animate(
      withDuration: 0.2, animations: {
        tapView.transform = tapView.transform.scaledBy(x: 1.2, y: 1.2)
      },
      completion: { _ in
        UIView.animate(withDuration: 0.2) {
          tapView.transform = previouTransform
        }
      })
  }
}




