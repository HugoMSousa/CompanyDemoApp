//
//  ModuleBuilder.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import UIKit

class ModuleBuilder: IModuleBuilder {}

extension ModuleBuilder {
  
  func builDataStore() -> IDataStore {
    return DataStore.sharedInstance
  }
  
  func buildUserListModuleFromCompany(companyId: String, delegate: UserListModuleDelegate) -> UIViewController {
    
    let viewController = ListViewController()
    let usersInteractor = UsersInteractor()
    
    let presenter = UserListPresenter(view: viewController, moduleDelegate: delegate, usersInteractor: usersInteractor)
    
    viewController.eventHandler = presenter
    usersInteractor.output = presenter
    usersInteractor.dataStore = builDataStore()
    
    return viewController
  }
}

extension ModuleBuilder {
  
  func buildAlbumListModuleFromUser(user: UserViewModel, delegate: AlbumListModuleDelegate) -> UIViewController {
    
    let viewController = ListViewController()
    let albumsInteractor = AlbumsInteractor()
    
    let presenter = AlbumListPresenter(user: user, view: viewController, moduleDelegate: delegate, albumsInteractor: albumsInteractor)
    
    let title = "Albums of \(user.name)"
    viewController.title = NSLocalizedString(title, comment: "")
    viewController.eventHandler = presenter
    albumsInteractor.output = presenter
    albumsInteractor.dataStore = builDataStore()
    
    return viewController
  }
}

extension ModuleBuilder {
  
  func buildPhotoListModuleFromAlbum(album: AlbumViewModel, delegate: PhotoListModuleDelegate) -> UIViewController {
    
    let viewController = ListViewController()
    let photosInteractor = PhotosInteractor()
    
    let presenter = PhotoListPresenter(album: album, view: viewController, moduleDelegate: delegate, photosInteractor: photosInteractor)
    
    let title = "Photos of \(album.title)"
    viewController.title = NSLocalizedString(title, comment: "")
    viewController.eventHandler = presenter
    photosInteractor.output = presenter
    photosInteractor.dataStore = builDataStore()
    
    return viewController
  }
}