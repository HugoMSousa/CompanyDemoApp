//
//  UserListPresenter.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 08/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

class UserListPresenter: IListViewEventHandler, IUsersInteractorOutput {
  
  weak var moduleDelegate: UserListModuleDelegate?
  weak var view: IListView?
  let usersInteractor: IUsersInteractorInput
  
  var viewModel = Array<UserViewModel>() {
    didSet {
      self.generateFilteredViewModel()
      self.displayViewModel(filteredViewModel)
    }
  }
  var filteredViewModel = Array<UserViewModel>()
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
  
  init(view: IListView, moduleDelegate: UserListModuleDelegate, usersInteractor: IUsersInteractorInput) {
    self.view = view
    self.moduleDelegate = moduleDelegate
    self.usersInteractor = usersInteractor
  }
  
  // MARK: IUserListViewEventHandler
  func didLoad() {
    self.view?.setListTitle(NSLocalizedString("userListViewController.title", comment: "User List Title"))
  }
  
  func didBeginRefresh() {
    self.usersInteractor.provideAllUsers()
  }
  
  func didSelectItemAtIndexPath(indexPath: NSIndexPath) {
    moduleDelegate?.userListModuleDidSelectUser(filteredViewModel[indexPath.row])
  }
  
  func didChangeFilterValue(value: String) {
    filterValue = value
  }
  
  func didChangeFilterMode(enabled: Bool) {
    filterModeEnabled = enabled
  }
  
  func displayViewModel(viewModel: Array<UserViewModel>) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
      if let sectionConfigurators = self?.bindUserViewModels(viewModel) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
          self?.view?.setListItems(sectionConfigurators)
        }
      }
    }
  }
  
  // MARK: IUsersInteractorOutput
  func receiveError(error: NSError) {
    view?.setErrorAlert("Something went wrong", message:"Error: "+error.localizedDescription)
  }
  
  func receiveAllUsers(users: Array<User>) {
    
    var viewModel = Array<UserViewModel>()
    
    if users.count == 0 {
      view?.setErrorAlert("Something went wrong", message:"0 Results")
      return
    }
    
    for user in users {
      viewModel.append(UserViewModel(user: user))
    }
    self.viewModel = viewModel
  }
  
  // MARK: Private Methods
  private func generateFilteredViewModel() {
    if filterValue.isEmpty {
      filteredViewModel = viewModel
    } else {
      filteredViewModel = viewModel.filter { userViewModel in
        return userViewModel.name.lowercaseString.containsString(filterValue.lowercaseString)
      }
    }
  }
  
  private func bindUserViewModels(userViewModels: Array<UserViewModel>) -> [SectionConfigurator] {
    
    var cellConfigurators = Array<CellConfiguratorType>()
    for userViewModel in userViewModels {
      let cellConfigurator = CellConfigurator<UserTableViewCell>(viewModel:userViewModel)
      cellConfigurators.append(cellConfigurator)
    }
    return [SectionConfigurator(cellConfigurators: cellConfigurators)]
  }
}