//
//  PhotosInteractor.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

class PhotosInteractor : IPhotosInteractorInput {
  
  weak var output: IPhotosInteractorOutput?
  weak var dataStore: IDataStore?
  
  var photos = Array<Photo>()
  
  func provideAllPhotosOfAlbum(albumId: Int) {
    let predicate = NSPredicate(format: "%K = %d","id", albumId)
    
    if let albums = self.dataStore?.fetch(Album.self, predicate:
      predicate) {
        
        if let album = albums.first {
          let photos = album.photos?.allObjects as? Array<Photo> ?? Array<Photo>()
          self.output?.receiveAllPhotos(photos)
          
        } else {
          self.output?.receiveAllPhotos(Array<Photo>())
        }
    } else {
      self.output?.receiveAllPhotos(Array<Photo>())
    }
  }
}