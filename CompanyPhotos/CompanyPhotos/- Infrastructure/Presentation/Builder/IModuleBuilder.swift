//
//  IModuleBuilder.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import UIKit

protocol IModuleBuilder {
  
  func buildUserListModuleFromCompany(companyId: String, delegate: UserListModuleDelegate) -> UIViewController
  func buildAlbumListModuleFromUser(user: UserViewModel, delegate: AlbumListModuleDelegate) -> UIViewController
  func buildPhotoListModuleFromAlbum(album: AlbumViewModel, delegate: PhotoListModuleDelegate) -> UIViewController
}