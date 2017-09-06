//
//  ItemType+CoreDataProperties.swift
//  MyProducts
//
//  Created by Jack Ily on 06/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
