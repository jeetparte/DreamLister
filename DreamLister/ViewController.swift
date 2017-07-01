//
//  ViewController.swift
//  DreamLister
//
//  Created by Jeet Parte on 24/06/17.
//  Copyright © 2017 Jeet Parte. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var fetchedResultsController: NSFetchedResultsController<Item>!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        do {
            let itemFetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            let noOfSavedItems = try context.count(for: itemFetchRequest)
            //generate sample items if no items exist
            if noOfSavedItems <= 0 {
                generateTestData()
            }
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
        attemptFetch()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        self.configureCell(cell, at: indexPath)
        return cell
    }
    
    private func configureCell(_ cell: ItemCell, at indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        cell.configureCell(from: item)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let numberOfRows = sections[section].numberOfObjects
            return numberOfRows
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItem = fetchedResultsController.fetchedObjects?[indexPath.row] {
            performSegue(withIdentifier: "selectedItemDetails", sender: selectedItem)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedItemDetails" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let selectedItem = sender as? Item {
                    destination.itemToEdit = selectedItem
                }
            }
        }
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            fetchRequest.sortDescriptors = [dateSort]
        case 1:
            fetchRequest.sortDescriptors = [titleSort]
        case 2:
            fetchRequest.sortDescriptors = [priceSort]
        default:
            fetchRequest.sortDescriptors = [dateSort]
            break
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.fetchedResultsController = controller
        
        do {
            try controller.performFetch()
        } catch{
            let error = error as NSError
            print("\(error)")
        }
    }
    
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        attemptFetch()
        tableView.reloadData()
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.fade)
            }
            
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                tableView.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.fade)
            }
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                self.configureCell(cell, at: indexPath)
            }
            break;
        }
    }
    
    func generateTestData() {
        let item = Item(context: context)
        item.title = "MacBook Pro"
        let itemType = ItemType(context: context)
        itemType.type = "Laptop"
        item.toItemType = itemType
        item.price = 1800
        item.details = "I can't wait until the September event, I hope they release new MPBs"
        let mbpImage = Image(context: context)
        mbpImage.image = #imageLiteral(resourceName: "mbp")
        item.toImage = mbpImage
        
        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        let itemType2 = ItemType(context: context)
        itemType2.type = "Audio accessories"
        item2.toItemType = itemType2
        item2.price = 300
        item2.details = "But man, its so nice to be able to block out everyone with the noise canceling tech."
        let headphoneImage = Image(context: context)
        headphoneImage.image = #imageLiteral(resourceName: "bose")
        item2.toImage = headphoneImage
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        let itemType3 = ItemType(context: context)
        itemType3.type = "Automobile"
        item3.toItemType = itemType3
        item3.price = 110000
        item3.details = "Oh man this is a beautiful car. And one day, I willl own it"
        let teslaImage = Image(context: context)
        teslaImage.image = #imageLiteral(resourceName: "tesla")
        item3.toImage = teslaImage
        
        appDelegate.saveContext()
    }
}

