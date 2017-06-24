//
//  Store+CoreDataProperties.swift
//  DreamLister
//
//  Created by Jeet Parte on 24/06/17.
//  Copyright © 2017 Jeet Parte. All rights reserved.
//

import Foundation
import CoreData


extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store")
    }

    @NSManaged public var name: String?
    @NSManaged public var toItem: NSSet?
    @NSManaged public var toItemType: NSSet?

}

// MARK: Generated accessors for toItem
extension Store {

    @objc(addToItemObject:)
    @NSManaged public func addToToItem(_ value: Item)

    @objc(removeToItemObject:)
    @NSManaged public func removeFromToItem(_ value: Item)

    @objc(addToItem:)
    @NSManaged public func addToToItem(_ values: NSSet)

    @objc(removeToItem:)
    @NSManaged public func removeFromToItem(_ values: NSSet)

}

// MARK: Generated accessors for toItemType
extension Store {

    @objc(addToItemTypeObject:)
    @NSManaged public func addToToItemType(_ value: ItemType)

    @objc(removeToItemTypeObject:)
    @NSManaged public func removeFromToItemType(_ value: ItemType)

    @objc(addToItemType:)
    @NSManaged public func addToToItemType(_ values: NSSet)

    @objc(removeToItemType:)
    @NSManaged public func removeFromToItemType(_ values: NSSet)

}
