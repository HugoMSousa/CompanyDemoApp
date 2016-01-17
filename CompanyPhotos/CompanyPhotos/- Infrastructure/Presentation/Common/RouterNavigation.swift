//
//  RouteStackNavigation.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 10/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import UIKit

protocol StackRoutable {
  var navigationController: UINavigationController { get }
  init()
}

protocol TabRoutable {
  var tabController: UITabBarController { get }
}