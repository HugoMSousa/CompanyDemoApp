//
//  Updatable.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 09/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

protocol Updatable: class {
  
  typealias ViewModel
  
  func updateWithViewModel(viewModel: ViewModel)
}
