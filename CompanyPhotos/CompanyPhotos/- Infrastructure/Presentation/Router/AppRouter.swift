//
//  AppsRouter.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import UIKit

class AppRouter: IStackNavigationRouter {
  
  let navigationController: UINavigationController
  let moduleBuilder: IModuleBuilder
  
  required init(navigationController: UINavigationController, moduleBuilder: IModuleBuilder) {
    self.navigationController = navigationController
    self.moduleBuilder = moduleBuilder
  }
  
  // very simple navigation strategy
  func push(route: Route, animated: Bool) {
    
    var viewController: UIViewController!
    switch route {
    case let .UserListModule(companyId):
      viewController = self.moduleBuilder.buildUserListModuleFromCompany(companyId, delegate: self)
    case let .AlbumListModule(user):
      viewController = self.moduleBuilder.buildAlbumListModuleFromUser(user, delegate: self)
    case let .PhotoListModule(album):
      viewController = self.moduleBuilder.buildPhotoListModuleFromAlbum(album, delegate: self)
    default:
      break
    }
    if viewController != nil {
      self.navigationController.pushViewController(viewController, animated: animated)
    }
  }
  
  func popAnimated(animated: Bool) {
    self.navigationController.popViewControllerAnimated(animated)
  }
}

extension AppRouter: UserListModuleDelegate {
  func userListModuleDidSelectUser(user: UserViewModel) {
    self.push(Route.AlbumListModule(user: user), animated: true)
  }
}

extension AppRouter: AlbumListModuleDelegate {
  func albumListModuleDidSelectAlbum(album: AlbumViewModel) {
     self.push(Route.PhotoListModule(album: album), animated: true)
  }
}

extension AppRouter: PhotoListModuleDelegate {
  func photoListModuleDidSelectPhoto(photo: PhotoViewModel) {
    
  }
}