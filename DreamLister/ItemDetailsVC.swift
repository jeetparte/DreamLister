//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Jeet Parte on 29/06/17.
//  Copyright © 2017 Jeet Parte. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var previewImageButton: UIButton!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var descriptionField: CustomTextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    private var stores = [Store]()
    private var imagePicker: UIImagePickerController!
    var itemToEdit: Item?
    
    override func viewWillAppear(_ animated: Bool) {
        if itemToEdit != nil { //Edit existing item
            self.navigationItem.title = "Edit item"
        } else { //Add new item
            self.navigationItem.title = "Add new item"
            trashButton.isEnabled = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewImageButton.imageView?.contentMode = .scaleAspectFit
        
        imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if itemToEdit != nil { //Edit existing item
            loadItemData()
        }

//        generateStoreData()
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
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            descriptionField.text = item.details
            if let itemImage = item.toImage?.image as? UIImage {
                previewImageButton.setImage(itemImage, for: .normal)
            }
            
            var index = 0
            while index < stores.count {
                let store = stores[index]
                if store.name == item.toStore?.name {
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                    break
                }
                index += 1
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let item: Item = itemToEdit == nil ? Item(context: context) : itemToEdit!
        
        item.title = titleField.text
        item.price = Double(priceField.text!) ?? 0
        item.details = descriptionField.text
        let selectedStore = stores[pickerView.selectedRow(inComponent: 0)]
        item.toStore = selectedStore
        let image = Image(context: context)
        image.image = previewImageButton.currentImage
        item.toImage = image
        
        appDelegate.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func changeImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            previewImageButton.setImage(image, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
