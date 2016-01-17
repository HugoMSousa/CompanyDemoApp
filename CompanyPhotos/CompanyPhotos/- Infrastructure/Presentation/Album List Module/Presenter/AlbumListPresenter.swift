//
//  AlbumListPresenter.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

class AlbumListPresenter: IListViewEventHandler, IAlbumsInteractorOutput {
  
  weak var moduleDelegate: AlbumListModuleDelegate?
  weak var view: IListView?
  let albumsInteractor: IAlbumsInteractorInput
  
  var user: UserViewModel
  
  var viewModel = Array<AlbumViewModel>() {
    didSet {
      self.generateFilteredViewModel()
      self.displayViewModel(filteredViewModel)
    }
  }
  var filteredViewModel = Array<AlbumViewModel>()
  var filterModeEnabled: Bool = false {
    didSet {
      if !filterModeEnabled {
        filterValue = ""
      }
    }
  }
  var filterValue = "" {
    didSet {
      self.generateFilteredViewModel()
      self.displayViewModel(filteredViewModel)
    }
  }
  
  init(user: UserViewModel, view: IListView, moduleDelegate: AlbumListModuleDelegate, albumsInteractor: IAlbumsInteractorInput) {
    self.view = view
    self.moduleDelegate = moduleDelegate
    self.albumsInteractor = albumsInteractor
    self.user = user
  }
  
  // MARK: IAlbumListViewEventHandler
  func didLoad() {}
  
  func didBeginRefresh() {
    let userOwnerId: Int = Int(user.id)! ?? 0
    self.albumsInteractor.provideAllAlbumsOfUser(userOwnerId)
  }
  
  func didSelectItemAtIndexPath(indexPath: NSIndexPath) {
    moduleDelegate?.albumListModuleDidSelectAlbum(filteredViewModel[indexPath.row])
  }
  
  func didChangeFilterValue(value: String) {
    filterValue = value
  }
  
  func didChangeFilterMode(enabled: Bool) {
    filterModeEnabled = enabled
  }
  
  func displayViewModel(viewModel: Array<AlbumViewModel>) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
      if let sectionConfigurators = self?.bindAlbumViewModels(viewModel) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
          self?.view?.setListItems(sectionConfigurators)
        }
      }
    }
  }
  
  // MARK: IAlbumsInteractorOutput
  func receiveError(error: NSError) {
    view?.setErrorAlert("Something went wrong", message:"Error: "+error.localizedDescription)
  }
  
  func receiveAllAlbums(albums: Array<Album>) {
    
    var viewModel = Array<AlbumViewModel>()
    
    if albums.count == 0 {
      view?.setErrorAlert("Something went wrong", message:"0 Results")
      return
    }
    
    for album in albums {
      viewModel.append(AlbumViewModel(album: album))
    }
    self.viewModel = viewModel
  }
  
  // MARK: Private Methods
  private func generateFilteredViewModel() {
    if filterValue.isEmpty {
      filteredViewModel = viewModel
    } else {
      filteredViewModel = viewModel.filter { albumViewModel in
        return albumViewModel.title.lowercaseString.containsString(filterValue.lowercaseString)
      }
    }
  }
  
  private func bindAlbumViewModels(albumViewModels: Array<AlbumViewModel>) -> [SectionConfigurator] {
    
    var cellConfigurators = Array<CellConfiguratorType>()
    for albumViewModel in albumViewModels {
      let cellConfigurator = CellConfigurator<AlbumTableViewCell>(viewModel:albumViewModel)
      cellConfigurators.append(cellConfigurator)
    }
    return [SectionConfigurator(cellConfigurators: cellConfigurators)]
  }
}
