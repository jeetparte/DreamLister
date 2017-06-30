//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Jeet Parte on 29/06/17.
//  Copyright © 2017 Jeet Parte. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var imagePreview: UIButton!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var descriptionField: CustomTextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    private var stores = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePreview.imageView?.contentMode = .scaleAspectFit
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        generateStoreData()
        getStores()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stores[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //TODO:
    }
    
    func generateStoreData() {
        for x in 1...4 {
            let store = Store(context: context)
            switch x {
            case 1:
                store.name = "Amazon"
            case 2:
                store.name = "Flipkart"
            case 3:
                store.name = "K Mart"

            case 4:
                store.name = "Tesla Dealership"
            default:
                break
            }
        }
        appDelegate.saveContext()
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.pickerView.reloadAllComponents()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let item = Item(context: context)
        
        item.title = titleField.text
        item.price = Double(priceField.text!) ?? 0
        item.details = descriptionField.text
        let selectedStore = stores[pickerView.selectedRow(inComponent: 0)]
        item.addToToStore(selectedStore)
        
        appDelegate.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
}
