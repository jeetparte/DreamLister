//
//  ItemCell.swift
//  DreamLister
//
//  Created by Jeet Parte on 27/06/17.
//  Copyright © 2017 Jeet Parte. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    
    func configureCell(from item: Item) {
        title.text = item.title
        type.text = item.toItemType?.type
        price.text = "$\(Int(item.price))"
        itemDescription.text =  item.details
        if let itemImage = item.toImage?.image as? UIImage {
            thumbnail.image = itemImage
        } else {
            thumbnail.image = #imageLiteral(resourceName: "imagePick")
        }
    }
}
