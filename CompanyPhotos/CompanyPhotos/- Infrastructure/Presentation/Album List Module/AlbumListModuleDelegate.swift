//
//  AlbumListModuleDelegate.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

protocol AlbumListModuleDelegate: class {
  func albumListModuleDidSelectAlbum(album: AlbumViewModel)
}