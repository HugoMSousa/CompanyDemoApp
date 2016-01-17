//
//  UIViewController+Extensions.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 09/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import UIKit


extension NSObject {
  
  class var className: String {
    get {
      return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
  }
}