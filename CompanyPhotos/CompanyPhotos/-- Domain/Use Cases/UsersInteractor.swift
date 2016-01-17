//
//  UsersInteractor.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

class UsersInteractor : IUsersInteractorInput {
  
  weak var output: IUsersInteractorOutput?
  weak var dataStore: IDataStore?
  
  var users = Array<User>()
  
  func provideAllUsers() {
    
    dataStore?.syncFromRemoteFetch({ [weak self] success, error in
      if success {
        
        if let users = self?.dataStore?.fetch(User.self, predicate: nil) {
          self?.output?.receiveAllUsers(users)
        } else {
          self?.output?.receiveAllUsers(Array<User>())
        }
        
      } else {
        self?.output?.receiveError(error!)
      }
    })
  }
}
