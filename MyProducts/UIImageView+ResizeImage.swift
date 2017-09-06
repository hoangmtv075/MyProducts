//
//  UIImageView+ResizeImage.swift
//  MyProducts
//
//  Created by Jack Ily on 06/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizeImage(_ bounds: CGSize) -> UIImage {
        let horizontalRario = bounds.width / size.width
        let verticalRatio = bounds.height / size.height
        let ratio = min(horizontalRario, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
