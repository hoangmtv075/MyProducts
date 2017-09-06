//
//  Configure+UIView.swift
//  MyProducts
//
//  Created by Jack Ily on 05/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import UIKit

private var configureKey = false

extension UIView {
    
    @IBInspectable var configureView: Bool {
        get {
            return configureKey
        }
        set {
            configureKey = newValue
            
            if configureKey {
                self.clipsToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1).cgColor
                
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
    }
}
