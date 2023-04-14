//
//  AlbumInfo.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/14/23.
//

import Foundation
import Photos

struct AlbumInfo: Identifiable {
  let id: String?
  let name: String
  let count: Int
  let album: PHFetchResult<PHAsset>
}
