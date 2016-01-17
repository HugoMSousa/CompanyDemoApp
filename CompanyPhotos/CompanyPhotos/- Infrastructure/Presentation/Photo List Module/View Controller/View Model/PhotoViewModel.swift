//
//  PhotoViewModel.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 17/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

struct PhotoViewModel {
  var id: String = ""
  var name: String = ""
  var urlThumbnailString: String = ""
  
  init(photo: Photo) {
    self.id = String(photo.id)
    self.name = photo.title ?? ""
    self.urlThumbnailString = photo.thumbnailUrl ?? ""
  }
}