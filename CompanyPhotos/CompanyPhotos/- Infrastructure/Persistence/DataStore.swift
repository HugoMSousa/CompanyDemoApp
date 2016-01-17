//
//  File.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 11/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation
import CoreData

class DataStore: IDataStore {
  
  private var persistentStoreURL: NSURL = {
    let documentDirectory: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    return documentDirectory.URLByAppendingPathComponent("CoreData.sqlite")
  }()
  
  private  lazy var mom: NSManagedObjectModel = {
    let modelURL = NSBundle.mainBundle().URLForResource("ModelSchema", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
  }()
  
  private  lazy var psc: NSPersistentStoreCoordinator = {
    let psc = NSPersistentStoreCoordinator(managedObjectModel: self.mom)
    do {
      try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.persistentStoreURL, options:nil)
    } catch {
      let error = NSError(domain: "DataStoreDomain", code: 9999, userInfo: [
        "NSLocalizedDescriptionKey": "Failed to initialize CoreData Store",
        "NSLocalizedFailureReasonErrorKey": "Error in creating or loading CoreData Store."
      ])
      NSLog("Unresolved error \(error), \(error.userInfo)")
      abort()
    }
    return psc
  }()
  
  private lazy var moc: NSManagedObjectContext = {
    let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    moc.persistentStoreCoordinator = self.psc
    return moc
  }()
  
  private lazy var bgMoc: NSManagedObjectContext = {
    let bgMoc = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    bgMoc.persistentStoreCoordinator = self.psc
    return bgMoc
  }()
  
  static let sharedInstance = DataStore()
  var remoteAPI: CompanyAPI?
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  private init() {
  
    NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: nil, queue: nil) { notification in
      if let bgMoc = notification.object as? NSManagedObjectContext {
        if bgMoc == self.bgMoc {
          self.moc.mergeChangesFromContextDidSaveNotification(notification)
        }
      }
    }
  }
  
  func syncFromRemoteFetch(completion: (Bool, NSError?) -> Void) {
  
    CompanyWebService.request(APIEndpoints.Users) { response in
      switch response.result {
      case .Failure(let error):
        NSOperationQueue.mainQueue().addOperationWithBlock{ completion(false, error)}
      case .Success(let usersData):
        CompanyWebService.request(APIEndpoints.Albums) { response in
          switch response.result {
          case .Failure(let error):
            NSOperationQueue.mainQueue().addOperationWithBlock{ completion(false, error)}
          case .Success(let albumsData):
            CompanyWebService.request(APIEndpoints.Photos) { response in
              switch response.result {
              case .Failure(let error): completion(false, error)
              case .Success(let photosData):
                
                self.bgMoc.performBlock({
                
                  // Delete All Objects in core data
                  self.deleteAllObjects()
                  
                  let usersDict = usersData as! Array<NSDictionary>
                  let albumsDict = albumsData as! Array<NSDictionary>
                  let photosDict = photosData as! Array<NSDictionary>
                  
                  // Repopulate the new users
                  for userDict in usersDict {
                    
                    let companyDict = userDict["company"] as! NSDictionary
                    let addressDict = userDict["address"] as! NSDictionary
                  
                    // Create Company
                    let companyName = companyDict["name"] as! String
                    let company: Company = self.fetchOrCreateByIdentifier(Company.self, predicate: NSPredicate(format: "%@ = %@","name", companyName))
                    company.name = companyName
                    company.catchPhrase = companyDict["catchPhrase"] as? String
                    company.bs = companyDict["name"] as? String
                    
                    // Create Address
                    let address: Address = self.createNew(Address.self)
                    address.street = addressDict["street"] as? String
                    address.suite = addressDict["suite"] as? String
                    address.city = addressDict["city"] as? String
                    address.zipcode = addressDict["zipcode"] as? String
                    address.geoLat = addressDict["geo"]?["lat"] as? String
                    address.geoLng = addressDict["geo"]?["lng"] as? String
                    
                    // Create User
                    let user: User = self.createNew(User.self)
                    user.id = Int32( userDict["id"] as? Int ?? 0 )
                    user.name = userDict["name"] as? String
                    user.username = userDict["username"] as? String
                    user.email = userDict["email"] as? String
                    user.phone = userDict["phone"] as? String
                    user.website = userDict["website"] as? String
                    user.address = address
                    user.company = company
                  }
                  try! self.bgMoc.save()
                 
                  // Repopulate the new albums
                  for albumDict in albumsDict {
                    // Create Album
                    let album: Album = self.createNew(Album)
                    album.id = Int32( albumDict["id"] as? Int ?? 0 )
                    album.title = albumDict["title"] as? String
                    let userId = Int32( albumDict["userId"] as? Int ?? 0 )
                    if let user = self.fetchExisting(User.self, predicate: NSPredicate(format: "%K = %d","id", userId)).first {
                      album.user = user
                    }
                  }
                  try! self.bgMoc.save()
                  
                  // Repopulate the new photos
                  var count = 0
                  let batchSize = 100
                  for photoDict in photosDict {
                    count++
                    // Create Photo
                    let photo: Photo = self.createNew(Photo)
                    photo.id = Int32( photoDict["id"] as? Int ?? 0 )
                    photo.title =  photoDict["title"] as? String
                    photo.url =  photoDict["url"] as? String
                    photo.thumbnailUrl =  photoDict["thumbnailUrl"] as? String
                    let albumId = Int32( photoDict["albumId"] as? Int ?? 0 )
                    if let album = self.fetchExisting(Album.self, predicate: NSPredicate(format: "%K = %d","id", albumId)).first {
                      photo.album = album
                    }
                    if count % batchSize == 0 {
                      try! self.bgMoc.save()
                    }
                  }
                
                  do {
                    try self.bgMoc.save()
                    NSOperationQueue.mainQueue().addOperationWithBlock{ completion(true, nil)}
                  } catch {
                    switch error {
                    default:
                      NSOperationQueue.mainQueue().addOperationWithBlock{ completion(false, NSError(domain: "DataStoreDomain", code: 9999, userInfo: ["NSLocalizedDescription": "Problem in DataStore syncing."]))}
                      break
                    }
                  }
                })
              }
            }
          }
        }
      }
    }
  }

  private func deleteAllObjects() {
    let fetchRequest = NSFetchRequest(entityName: Company.className)
  
    do {
      let array: NSArray = try self.bgMoc.executeFetchRequest(fetchRequest)
      if array.count > 0 {
        for objectToDelete in array {
          self.bgMoc.deleteObject(objectToDelete as! NSManagedObject)
        }
        try self.bgMoc.save()
      }
    } catch {
      switch error {
      default:
        print(error)
      }
    }
  }
 
  private func fetchOrCreateByIdentifier<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?) -> T {
    let array: [T] = fetchExisting(type, predicate: predicate)
      
    if let existing = array.first {
      return existing
    } else {
      return createNew(type)
    }
  }
  
  private func fetchExisting<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?) -> [T] {
    // Run the query
    let fetchRequest = NSFetchRequest(entityName: type.className)
    fetchRequest.predicate = predicate
    do {
      if let array: NSArray = try self.bgMoc.executeFetchRequest(fetchRequest) {
        return array as! [T]
      } else {
        return NSArray() as! [T]
      }
    } catch {
      return NSArray() as! [T]
    }
  }
  
  func fetch<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?) -> [T] {
    // Run the query
    let fetchRequest = NSFetchRequest(entityName: type.className)
    fetchRequest.predicate = predicate
    do {
      let array: NSArray = try self.moc.executeFetchRequest(fetchRequest)
      return array as! [T]
    } catch {
      return NSArray() as! [T]
    }
  }
  
  private func createNew<T: NSManagedObject>(type: T.Type) -> T {
    let entityDescription = NSEntityDescription.entityForName(type.className, inManagedObjectContext: self.bgMoc)
    return type.init(entity: entityDescription!, insertIntoManagedObjectContext: self.bgMoc)
  }
}
         