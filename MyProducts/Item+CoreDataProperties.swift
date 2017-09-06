//
//  Item+CoreDataProperties.swift
//  MyProducts
//
//  Created by Jack Ily on 06/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var title: String?
    @NSManaged public var price: Double
    @NSManaged public var details: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var toImage: Image?
    @NSManaged public var toItemType: ItemType?

}
