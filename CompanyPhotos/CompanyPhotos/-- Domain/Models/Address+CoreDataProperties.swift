//
//  Address+CoreDataProperties.swift
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

extension Address {

    @NSManaged var street: String?
    @NSManaged var suite: String?
    @NSManaged var city: String?
    @NSManaged var zipcode: String?
    @NSManaged var geoLat: String?
    @NSManaged var geoLng: String?
    @NSManaged var user: User?

}
