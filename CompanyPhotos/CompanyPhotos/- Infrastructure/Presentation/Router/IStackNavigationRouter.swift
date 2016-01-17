//
//  IStack.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import UIKit

protocol IStackNavigationRouter {
  var navigationController: UINavigationController { get }
  
  func push(route: Route, animated: Bool)
  func popAnimated(animated: Bool)
}
