//
//  ItemDetailVC.swift
//  MyProducts
//
//  Created by Jack Ily on 05/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var titleLbl: UITextField!
    @IBOutlet weak var priceLbl: UITextField!
    @IBOutlet weak var detailsLbl: UITextField!
    @IBOutlet weak var selectStoreLbl: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var addImageBtn: UIButton!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var stores = [String]()
    
    var editToItem: Item?
    
    var imgPicker: UIImage?
    
    var observer: AnyObject!
    
    deinit {
        print("*** deinit \(self)")
        NotificationCenter.default.removeObserver(observer)
    }
    
    func listentForBackgroundNotification() {
        observer = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main) { [weak self] (_) in
            if let strongSelf = self {
                if strongSelf.presentedViewController != nil {
                    strongSelf.dismiss(animated: false, completion: nil)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        loadPickerView()
        sortStore()
        loadDataDetail()
        
        listentForBackgroundNotification()
    }
    
    func loadPickerView() {
        let row = "iPhone"
        stores.append(row)
        
        let row1 = "iMac"
        stores.append(row1)
        
        let row2 = "iPod"
        stores.append(row2)
        
        let row3 = "iPad"
        stores.append(row3)
        
        let row4 = "Macbook Pro"
        stores.append(row4)
        
        let row5 = "Macbook Air"
        stores.append(row5)
        
        let row6 = "Apple Watch"
        stores.append(row6)
    }
    
    func sortStore() {
        stores.sort(by: { $0 < $1 })
        for i in 0..<stores.count {
            NSLog(stores[i])
        }
    }
    
    func loadDataDetail() {
        if let item = editToItem {
            title = "Edit Item"
            
            titleLbl.text = item.title
            priceLbl.text = "\(item.price)"
            detailsLbl.text = item.details
            
            let st = item.stores
            var index = 0
            repeat {
                let st1 = stores[index]
                
                if st == st1 {
                    self.pickerView.selectRow(index, inComponent: 0, animated: false)
                }
                index += 1
                
            } while (index < stores.count)
            
            if let img = item.toImage {
                if img.hasPhoto, let image = img.imgPhoto {
                    showImage(image)
                }
            }
            
            if let types = item.toItemType {
                selectStoreLbl.text = types.type
            }
        }
    }
    
    @IBAction func SaveItemBtn(_ sender: UIButton) {
        let item: Item
        let imge = Image(context: managedObjectContext)
        let type = ItemType(context: managedObjectContext)
        if let temp = editToItem {
            item = temp
            
        } else {
            item = Item(context: managedObjectContext)
            item.toImage = imge
            imge.image = nil
        }
        
        item.title = titleLbl.text!
        item.price = (priceLbl.text! as NSString).doubleValue
        item.details = detailsLbl.text!
        item.stores = stores[self.pickerView.selectedRow(inComponent: 0)]
        item.toItemType = type
        type.type = selectStoreLbl.text!
        
        if let imgs = imgPicker {
            if let img = item.toImage {
                if !img.hasPhoto {
                    img.image = Image.nextPhotoID() as NSNumber
                }
                
                if let data = UIImageJPEGRepresentation(imgs, 0.5) {
                    
                    do {
                        try data.write(to: img.photoID, options: .atomic)
                        
                    } catch {
                        print("Save Image Error")
                    }
                }
            }
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Save Item Error")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TrashBtn(_ sender: UIBarButtonItem) {
        if let item = editToItem {
            
            do {
                managedObjectContext.delete(item)
                item.toImage?.deleteFilePhoto()
                try managedObjectContext.save()
                
            } catch {
                print("Delete Error")
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddImgBtn(_ sender: UIButton) {
        pickPhoto()
    }
    
    func showImage(_ image: UIImage) {
        thumbnailImg.image = image
        addImageBtn.setTitle("", for: .normal)
        thumbnailImg.frame.size = CGSize(width: 100, height: 100)
    }
}

extension ItemDetailVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return stores.count
    }
}

extension ItemDetailVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return stores[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectStoreLbl.text = "\(stores[row])"
    }
}

extension ItemDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showMenuPhoto()
            
        } else {
            chooseFromLibrary()
        }
    }
    
    func showMenuPhoto() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAC = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAC)
        
        let takePhotoAC = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            self.takePhoto()
        }
        alert.addAction(takePhotoAC)
        
        let choosePhotoAC = UIAlertAction(title: "Choose From Library", style: .default) { (_) in
            self.chooseFromLibrary()
        }
        alert.addAction(choosePhotoAC)
        
        present(alert, animated: true, completion: nil)
    }
    
    func takePhoto() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = .camera
        imgPicker.allowsEditing = true
        present(imgPicker, animated: true, completion: nil)
    }
    
    func chooseFromLibrary() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = true
        present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgPicker = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if let img = imgPicker {
            showImage(img)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
