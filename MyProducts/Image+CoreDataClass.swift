//
//  Image+CoreDataClass.swift
//  MyProducts
//
//  Created by Jack Ily on 06/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Image)
public class Image: NSManagedObject {

    var hasPhoto: Bool {
        return image != nil
    }
    
    var photoID: URL {
        assert(image != nil, "No Photo ID set")
        let filePhoto = "Photo-\(image!.intValue).jpg"
        return documentDirectory().appendingPathComponent(filePhoto)
    }
    
    var imgPhoto: UIImage? {
        return UIImage(contentsOfFile: photoID.path)
    }
    
    class func nextPhotoID() -> Int {
        let defaults = UserDefaults.standard
        let currentID = defaults.integer(forKey: "PhotoID")
        defaults.set(currentID + 1, forKey: "PhotoID")
        defaults.synchronize()
        return currentID
    }
    
    func deleteFilePhoto() {
        if hasPhoto {
            do {
                try FileManager.default.removeItem(at: photoID)
                
            } catch {
                print("Delete FilePhoto Error")
            }
        }
    }
}
