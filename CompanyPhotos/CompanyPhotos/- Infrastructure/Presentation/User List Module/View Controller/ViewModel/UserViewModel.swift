//
//  UserViewModel.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

struct UserViewModel {
  let id: String
  let name: String
  let email: String
  let catchPhrase: String
  
  init(id: String, name: String, email: String, catchPhrase: String) {
    self.id = id
    self.name = name
    self.email = email
    self.catchPhrase = catchPhrase
  }
  
  init(user: User) {
    self.id = String(user.id)
    self.name = user.name ?? ""
    self.email = user.email ?? ""
    self.catchPhrase = user.company?.catchPhrase ?? ""
  }
}