//
//  PhotosInteractorIO.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

protocol IPhotosInteractorInput {
  func provideAllPhotosOfAlbum(albumId: Int)
}

protocol IPhotosInteractorOutput: class {
  func receiveAllPhotos(photos: Array<Photo>)
  func receiveError(error: NSError)
}