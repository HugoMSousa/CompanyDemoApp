//
//  PhotoListPresenter.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 17/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

class PhotoListPresenter: IListViewEventHandler, IPhotosInteractorOutput {
  
  weak var moduleDelegate: PhotoListModuleDelegate?
  weak var view: IListView?
  let photosInteractor: IPhotosInteractorInput
  
  var album: AlbumViewModel
  
  var viewModel = Array<PhotoViewModel>() {
    didSet {
      self.generateFilteredViewModel()
      self.displayViewModel(filteredViewModel)
    }
  }
  var filteredViewModel = Array<PhotoViewModel>()
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
  
  init(album: AlbumViewModel, view: IListView, moduleDelegate: PhotoListModuleDelegate, photosInteractor: IPhotosInteractorInput) {
    self.view = view
    self.moduleDelegate = moduleDelegate
    self.photosInteractor = photosInteractor
    self.album = album
  }
  
  // MARK: IAlbumListViewEventHandler
  func didLoad() {}
  
  func didBeginRefresh() {
    let albumId: Int = Int(album.id)! ?? 0
    self.photosInteractor.provideAllPhotosOfAlbum(albumId)
  }
  
  func didSelectItemAtIndexPath(indexPath: NSIndexPath) {
    moduleDelegate?.photoListModuleDidSelectPhoto(filteredViewModel[indexPath.row])
  }
  
  func didChangeFilterValue(value: String) {
    filterValue = value
  }
  
  func didChangeFilterMode(enabled: Bool) {
    filterModeEnabled = enabled
  }
  
  func displayViewModel(viewModel: Array<PhotoViewModel>) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
      if let sectionConfigurators = self?.bindPhotoViewModels(viewModel) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
          self?.view?.setListItems(sectionConfigurators)
        }
      }
    }
  }
  
  // MARK: IPhotosInteractorOutput
  func receiveError(error: NSError) {
    view?.setErrorAlert("Something went wrong", message:"Error: "+error.localizedDescription)
  }
  
  func receiveAllPhotos(photos: Array<Photo>) {
    
    var viewModel = Array<PhotoViewModel>()
    
    if photos.count == 0 {
      view?.setErrorAlert("Something went wrong", message:"0 Results")
      return
    }
    
    for photo in photos {
      viewModel.append(PhotoViewModel(photo: photo))
    }
    self.viewModel = viewModel
  }
  
  // MARK: Private Methods
  private func generateFilteredViewModel() {
    if filterValue.isEmpty {
      filteredViewModel = viewModel
    } else {
      filteredViewModel = viewModel.filter { photoViewModel in
        return photoViewModel.name.lowercaseString.containsString(filterValue.lowercaseString)
      }
    }
  }
  
  private func bindPhotoViewModels(photoViewModels: Array<PhotoViewModel>) -> [SectionConfigurator] {
    
    var cellConfigurators = Array<CellConfiguratorType>()
    for photoViewModel in photoViewModels {
      let cellConfigurator = CellConfigurator<PhotoTableViewCell>(viewModel:photoViewModel)
      cellConfigurators.append(cellConfigurator)
    }
    return [SectionConfigurator(cellConfigurators: cellConfigurators)]
  }
}
