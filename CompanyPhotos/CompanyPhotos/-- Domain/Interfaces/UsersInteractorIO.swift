//
//  UsersInteractorIO.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

protocol IUsersInteractorInput {
  func provideAllUsers()
}

protocol IUsersInteractorOutput: class {
  func receiveAllUsers(users: Array<User>)
  func receiveError(error: NSError)
}