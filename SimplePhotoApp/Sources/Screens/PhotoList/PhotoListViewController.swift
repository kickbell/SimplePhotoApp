//
//  ViewController.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/12/23.
//

import UIKit
import Photos

final class PhotoListViewController: UIViewController {
  
  // MARK: - Views
  
  private let colletionViewFlowLayout: UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.sectionInset = UIEdgeInsets.init(top: Const.numberOfColumns , left: Const.numberOfColumns, bottom: 0, right: Const.numberOfColumns)
    flowLayout.minimumLineSpacing = Const.numberOfColumns
    flowLayout.minimumInteritemSpacing = Const.numberOfColumns
    flowLayout.itemSize = Const.itemSize
    return flowLayout
  }()
  
  private lazy var collecitonView: UICollectionView = {
    let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: self.colletionViewFlowLayout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(cellType: GridCell.self)
    return collectionView
  }()
  
  // MARK: - Properties
  
  private struct Const {
    static let numberOfColumns = 3.0
    static let width = (UIScreen.main.bounds.width - numberOfColumns * (numberOfColumns + 1)) / numberOfColumns
    static let itemSize = CGSize(width: width, height: width)
    static let scale = UIScreen.main.scale
  }
  
  weak var coordinator: PhotoCoordinator?
  
  private var phAssets = [PHAsset]() {
    didSet {
      updateUI()
    }
  }
  
  // MARK: - ViewLifeCycles
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
      status == .authorized ? self.fetch() : self.alert()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
  }
  
}

extension PhotoListViewController {
  
  // MARK: - Methods
  
  private func setupViews() {
    title = "Photo List"
    view.backgroundColor = .systemBackground
    view.addSubview(collecitonView)
    PhotoService.shared.delegate = self
  }
  
  private func updateUI() {
    DispatchQueue.main.async {
      self.collecitonView.reloadData()
    }
  }
  
  private func fetch() {
    PhotoService.shared.getAlbums(mediaType: .image, completion: { [weak self] albums in
      PhotoService.shared.getPHAssets(album: albums[0].album) {
        self?.phAssets = $0.reversed()
      }
    })
  }
  
  private func alert() {
    DispatchQueue.main.async {
      let title = "사진 앨범 접근 권한 없음"
      let message = "사진 앨범에 접근할 수 있는 권한이 없습니다. 접근 권한을 허용해야 합니다. 설정화면으로 이동하시겠습니까?"
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "이동", style: .destructive) { _ in
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url) }
      }
      let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
      alertController.addAction(okAction)
      alertController.addAction(cancelAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
}

// MARK: - PHPhotoLibraryChangeObserver

extension PhotoListViewController: PHPhotoLibraryChangeObserver {
  func photoLibraryDidChange(_ changeInstance: PHChange) {
    fetch()
  }
}

// MARK: - CollectionView

extension PhotoListViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard phAssets.count > 0 else { return }
    
    guard let cell = collectionView.cellForItem(at: indexPath) as? GridCell else {
      return
    }
    coordinator?.didSelectPhoto(with: cell.imageView.image)
  }
  
}

extension PhotoListViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return phAssets.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //    guard phAssets.isEmpty == false else { return UICollectionViewCell() }
    guard phAssets.count > 0 else { return UICollectionViewCell() }
    
    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GridCell.self)
    PhotoService.shared.fetchImage(
      asset: phAssets[indexPath.row],
      size: CGSize(width: Const.width * Const.scale, height: Const.width * Const.scale)) { [weak cell] image in
        cell?.configure(with: image)
      }
    return cell
  }
  
}




