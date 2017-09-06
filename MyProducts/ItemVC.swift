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
    
    lazy var fetchedResultsController: NSFetchedResultsController<Item> = {
        let fetchRequest = NSFetchRequest<Item>()
        
        let entity = Item.entity()
        fetchRequest.entity = entity
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            let sortDescriptor1 = NSSortDescriptor(key: "created", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor1]
            print(self.segmentedControl.selectedSegmentIndex)
            
        } else if self.segmentedControl.selectedSegmentIndex == 1 {
            let sortDescriptor2 = NSSortDescriptor(key: "price", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor2]
            print(self.segmentedControl.selectedSegmentIndex)
            
        } else if self.segmentedControl.selectedSegmentIndex == 2 {
            let sortDescriptor3 = NSSortDescriptor(key: "title", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor3]
            print(self.segmentedControl.selectedSegmentIndex)
        }
        
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "Item")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
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
        
        performFetch()
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
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            print("Error")
        }
        tableView.reloadData()
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            print("Error")
        }
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
