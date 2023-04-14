//
//  GraphicViewController.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/13/23.
//
import UIKit

final class GraphicViewController: UIViewController {
  
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

  private let colletionViewFlowLayout: UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.sectionInset = UIEdgeInsets.init(top: Const.numberOfColumns , left: Const.numberOfColumns, bottom: 0, right: Const.numberOfColumns)
    flowLayout.minimumLineSpacing = Const.numberOfColumns
    flowLayout.minimumInteritemSpacing = Const.numberOfColumns
    flowLayout.itemSize = Const.itemSize
    return flowLayout
  }()
  
  private lazy var collecitonView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.colletionViewFlowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(cellType: GridCell.self)
    collectionView.backgroundColor = .clear
    return collectionView
  }()
  
  private lazy var blurEffectView: UIVisualEffectView = {
    let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let blurEffectView = UIVisualEffectView(effect: effect)
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    return blurEffectView
  }()
  
  
  // MARK: - Properties
  
  private struct Const {
    static let numberOfColumns = 2.0
    static let width = (UIScreen.main.bounds.width - numberOfColumns * (numberOfColumns + 1)) / numberOfColumns
    static let itemSize = CGSize(width: width, height: width)
    static let scale = UIScreen.main.scale
  }

  private var imageAssets: [UIImage] = [] {
    didSet {
      updateUI()
    }
  }
  
  weak var coordinator: PhotoCoordinator?
  
  // MARK: - ViewLifeCycles

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
  }
  
}

// MARK: - Methods

extension GraphicViewController {
  
  private func updateUI() {
    DispatchQueue.main.async {
      self.collecitonView.reloadData()
    }
  }
  
  private func setupViews() {
    view.backgroundColor = .clear
    view.addSubview(blurEffectView)
    view.addSubview(collecitonView)
    view.addSubview(closeButton)
    
    (1...25).forEach { imageAssets.append(UIImage(named: "\($0)") ?? UIImage()) }
    
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      
      collecitonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      collecitonView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      collecitonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      collecitonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
  @objc
  private func closeButtonDidTap(sender: UIButton) {
    dismiss(animated: true)
  }
  
}


// MARK: - CollectionView

extension GraphicViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard imageAssets.isEmpty == false else { return }
    coordinator?.didSelectGraphic(with: imageAssets[indexPath.row], on: self)
  }
  
}

extension GraphicViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageAssets.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard imageAssets.isEmpty == false else { return UICollectionViewCell() }
    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GridCell.self)
    cell.configure(with: imageAssets[indexPath.row])
    return cell
  }
  
}
