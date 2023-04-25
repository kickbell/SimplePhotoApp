//
//  PhotoService.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/14/23.
//

import UIKit
import Photos

enum MediaType {
  case all
  case image
  case video
}

final class PhotoService: NSObject {
  static let shared = PhotoService()
  weak var delegate: PHPhotoLibraryChangeObserver?
  
  override private init() {
    super.init()
    PHPhotoLibrary.shared().register(self)
  }
  
  private enum Const {
    static let titleText: (MediaType?) -> String = { mediaType in
      switch mediaType {
      case .all:
        return "이미지와 동영상"
      case .image:
        return "이미지"
      case .video:
        return "동영상"
      default:
        return "비어있는 타이틀"
      }
    }
    static let predicate: (MediaType) -> NSPredicate = { mediaType in
      let format = "mediaType == %d"
      switch mediaType {
      case .all:
        return .init(
          format: format + " || " + format,
          PHAssetMediaType.image.rawValue,
          PHAssetMediaType.video.rawValue
        )
      case .image:
        return .init(
          format: format,
          PHAssetMediaType.image.rawValue
        )
      case .video:
        return .init(
          format: format,
          PHAssetMediaType.video.rawValue
        )
      }
    }
    static let sortDescriptors = [
      NSSortDescriptor(key: "creationDate", ascending: false),
      NSSortDescriptor(key: "modificationDate", ascending: false)
    ]
  }
  
  let imageManager = PHCachingImageManager()
  
  deinit {
    PHPhotoLibrary.shared().unregisterChangeObserver(self)
  }
  
  func getAlbums(mediaType: MediaType, completion: @escaping ([AlbumInfo]) -> Void) {
    var allAlbums = [AlbumInfo]()
    defer {
      completion(allAlbums)
    }
    
    let recentAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
    let photoAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)

    recentAlbums.enumerateObjects { collection,_,_ in
      let assets = PHAsset.fetchAssets(in: collection, options: nil)
      allAlbums.append(
        .init(
          id: collection.localIdentifier,
          name: "최근 항목",
          count: assets.count,
          album: assets
        )
      )
    }
    
    photoAlbums.enumerateObjects { collection,_,_ in
      let assets = PHAsset.fetchAssets(in: collection, options: nil)
      allAlbums.append(
        .init(
          id: collection.localIdentifier,
          name: collection.localizedTitle ?? "",
          count: assets.count,
          album: assets
        )
      )
    }
  }
  
  func getPHAssets(album: PHFetchResult<PHAsset>, completion: @escaping ([PHAsset]) -> Void) {
    var phAssets = [PHAsset]()
    
    album.enumerateObjects { asset, index, stopPointer in
      guard index <= album.count - 1 else {
        stopPointer.pointee = true
        return
      }
      phAssets.append(asset)
    }
    
    completion(phAssets)
  }
  
  func fetchImage(
    asset: PHAsset,
    size: CGSize = .zero,
    contentMode: PHImageContentMode = .aspectFill,
    completion: @escaping (UIImage) -> Void
  ) {
    let option = PHImageRequestOptions()
    option.isNetworkAccessAllowed = true // for icloud
    option.deliveryMode = .highQualityFormat
    
    self.imageManager.requestImage(
      for: asset,
      targetSize: size,
      contentMode: contentMode,
      options: option
    ) { image, _ in
      guard let image = image else { return }
      completion(image)
    }
  }
}

extension PhotoService: PHPhotoLibraryChangeObserver {
  func photoLibraryDidChange(_ changeInstance: PHChange) {
    self.delegate?.photoLibraryDidChange(changeInstance)
  }
}
