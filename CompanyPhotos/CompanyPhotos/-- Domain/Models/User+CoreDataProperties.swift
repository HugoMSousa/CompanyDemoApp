//
//  User+CoreDataProperties.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 15/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var id: Int32
    @NSManaged var name: String?
    @NSManaged var username: String?
    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var website: String?
    @NSManaged var address: Address?
    @NSManaged var company: Company?
    @NSManaged var albums: NSSet?

}
