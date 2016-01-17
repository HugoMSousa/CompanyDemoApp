//
//  Company+CoreDataProperties.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 14/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Company {

    @NSManaged var name: String?
    @NSManaged var bs: String?
    @NSManaged var catchPhrase: String?
    @NSManaged var users: NSSet?

}
