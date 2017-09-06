//
//  Image+CoreDataProperties.swift
//  MyProducts
//
//  Created by Jack Ily on 06/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var image: Int32
    @NSManaged public var toItem: Item?

}
