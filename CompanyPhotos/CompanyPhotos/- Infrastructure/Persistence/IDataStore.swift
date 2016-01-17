//
//  IDataStore.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 14/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation
import CoreData

protocol IDataStore: class {
  
  func syncFromRemoteFetch(completion: (Bool, NSError?) -> Void)

  func fetch<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?) -> [T]
}
