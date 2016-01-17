//
//  AlbumViewModel.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

struct AlbumViewModel {
  var id: String = ""
  var userId: String = ""
  var title: String = ""
  
  init(album: Album) {
    self.id = String(album.id)
    self.userId = String(album.user?.id)
    self.title = album.title ?? ""
  }
}
