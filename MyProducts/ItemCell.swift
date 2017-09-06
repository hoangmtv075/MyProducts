//
//  ItemCell.swift
//  MyProducts
//
//  Created by Jack Ily on 05/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ item: Item) {
        if item.title.isEmpty {
            titleLbl.text = item.toItemType?.type
            
        } else {
            titleLbl.text = item.title
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        if item.price == 0 {
            priceLbl.text = "$0.00"
            
        } else if let text = (item.price as NSNumber?) {
            priceLbl.text = numberFormatter.string(from: text)
        }
        
        if item.details.isEmpty {
            detailsLbl.text = "(No Details)"
            
        } else {
            detailsLbl.text = item.details
        }
        
        thumbnailImg.image = thumbnail(item)
    }

    func thumbnail(_ item: Item) -> UIImage {
        if let image = item.toImage {
            if image.hasPhoto, let img = image.imgPhoto {
                return img.resizeImage(CGSize(width: 100, height: 100))
            }
        }
        return UIImage(named: "NoPhoto")!.resizeImage(CGSize(width: 100, height: 100))
    }
}
