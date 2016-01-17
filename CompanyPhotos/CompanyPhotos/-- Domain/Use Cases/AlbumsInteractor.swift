//
//  AlbumsInteractor.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

class AlbumsInteractor : IAlbumsInteractorInput {
  
  weak var output: IAlbumsInteractorOutput?
  weak var dataStore: IDataStore?
  
  var albums = Array<Album>()
  
  func provideAllAlbumsOfUser(userId: Int) {
    let predicate = NSPredicate(format: "%K = %d","id", userId)
    
    if let users = self.dataStore?.fetch(User.self, predicate:
      predicate) {
      
      if let user = users.first {
        let albums = user.albums?.allObjects as? Array<Album> ?? Array<Album>()
        self.output?.receiveAllAlbums(albums)
        
      } else {
        self.output?.receiveAllAlbums(Array<Album>())
      }
    } else {
      self.output?.receiveAllAlbums(Array<Album>())
    }
  }
}