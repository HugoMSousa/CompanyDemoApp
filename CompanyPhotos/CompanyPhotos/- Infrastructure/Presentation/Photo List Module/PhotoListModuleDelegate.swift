//
//  PhotoListModuleDelegate.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 17/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

protocol PhotoListModuleDelegate: class {
  func photoListModuleDidSelectPhoto(photo: PhotoViewModel)
}