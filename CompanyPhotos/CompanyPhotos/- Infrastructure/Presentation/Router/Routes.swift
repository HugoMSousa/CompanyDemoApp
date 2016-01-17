//
//  Route.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

enum Route {
  case UserListModule(companyId: String)
  case AlbumListModule(user: UserViewModel)
  case PhotoListModule(album: AlbumViewModel)
}
