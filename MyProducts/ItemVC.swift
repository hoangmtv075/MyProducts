//
//  ViewController.swift
//  MyProducts
//
//  Created by Jack Ily on 06/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import UIKit
import CoreData

class ItemVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    deinit {
        fetchedResultsController.delegate = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        
        let tintColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
        segmentedControl.tintColor = tintColor
        
        performFetch()
    }
    
    func performFetch() {
        let fetchRequest = NSFetchRequest<Item>()
        
        let entity = Item.entity()
        fetchRequest.entity = entity
        
        let sortDescriptor1 = NSSortDescriptor(key: "created", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "price", ascending: true)
        let sortDescriptor3 = NSSortDescriptor(key: "title", ascending: true)
        
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            fetchRequest.sortDescriptors = [sortDescriptor1]
        case 1:
            fetchRequest.sortDescriptors = [sortDescriptor2]
        case 2:
            fetchRequest.sortDescriptors = [sortDescriptor3]
        default:
            break
        }
        
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "Item")
        self.fetchedResultsController = fetchedResultsController
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            print("Error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailVC
            controller.managedObjectContext = managedObjectContext
            
        } else if segue.identifier == "ItemDetailVC" {
            let controller = segue.destination as! ItemDetailVC
            controller.managedObjectContext = managedObjectContext
            
            if let item = sender as? Item {
                controller.editToItem = item
            }
        }
    }
    
    @IBAction func SegmentedChanged(_ sender: UISegmentedControl) {
        performFetch()
        tableView.reloadData()
    }
}

extension ItemVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = fetchedResultsController.sections![section]
        return sections.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item = fetchedResultsController.object(at: indexPath)
        
        cell.configureCell(item)
        
        return cell
    }
}

extension ItemVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "ItemDetailVC", sender: item)
    }
}

extension ItemVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** Begin Updates")
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .insert:
            print("*** Insert Object")
            tableView.insertRows(at: [newIndexPath!], with: .none)
        case .delete:
            print("*** Delete Object")
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            print("*** Update Object")
            if let cell = tableView.cellForRow(at: indexPath!) as? ItemCell {
                let item = controller.object(at: indexPath!) as! Item
                cell.configureCell(item)
            }
        case .move:
            print("*** Move Object")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .none)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** End Updates")
        tableView.endUpdates()
    }
}
