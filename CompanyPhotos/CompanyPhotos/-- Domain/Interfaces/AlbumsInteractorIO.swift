//
//  AlbumsInteractorIO.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

protocol IAlbumsInteractorInput {
  func provideAllAlbumsOfUser(userId: Int)
}

protocol IAlbumsInteractorOutput: class {
  func receiveAllAlbums(albums: Array<Album>)
  func receiveError(error: NSError)
}