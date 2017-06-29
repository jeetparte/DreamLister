//
//  ViewController.swift
//  DreamLister
//
//  Created by Jeet Parte on 24/06/17.
//  Copyright © 2017 Jeet Parte. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var fetchedResultsController: NSFetchedResultsController<Item>!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        generateTestData()
        attemptFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController = controller
        
        do {
            try controller.performFetch()
        } catch{
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
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
        //TODO
        
        item.title = "MacBook Pro"
        item.price = 1800
        item.details = "I can't wait until the September event, I hope they release new MPBs"
        
        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        item2.price = 300
        item2.details = "But man, its so nice to be able to blaock out everyone with the noise canceling tech."
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "Oh man this is a beautiful car. And one day, I willl own it"
        
        appDelegate.saveContext()
    }

}

