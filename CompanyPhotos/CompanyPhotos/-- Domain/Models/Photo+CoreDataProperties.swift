//
//  Photo+CoreDataProperties.swift
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

extension Photo {

    @NSManaged var id: Int32
    @NSManaged var title: String?
    @NSManaged var url: String?
    @NSManaged var thumbnailUrl: String?
    @NSManaged var album: Album?

}
