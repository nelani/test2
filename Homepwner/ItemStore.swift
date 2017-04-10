//
//  ItemStore.swift
//  Homepwner
//
//  Created by Nelani Dlamini on 2017/03/14.
//  Copyright © 2017 Nelani Dlamini. All rights reserved.
//

import UIKit

class ItemStore{
    
    var allItems = [Item]()
    
    //Implement method to load instances of Item when the application launches 
    init(){
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item] {
            allItems = archivedItems
        }
    }
    
    
    //Implement method to construct URL to a file in the Documents directory where the instances of Item will be saved
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    //impplement a method to save instances of Item when the application exits
    func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }
    
    //implement createItem() to create and return a new Item
    func createItem(_ newItem: Item){
        
        allItems.append(newItem)
        
    }
    
    //Implement a new method to remove a specific item 
    
    func removeItem(_ item: Item){
        if let index = allItems.index(of: item){
            allItems.remove(at: index)
        }
    }
    //Implement a method to change the order of items in its allItems array
    func moveItem(from fromIndex: Int, to toIndex: Int){
        if fromIndex == toIndex{
            return
        }
        
        //Get reference to object being moved so you can reinsert it 
        let movedItem = allItems[fromIndex]
        
        //Remove item from array
        allItems.insert(movedItem, at: toIndex)
    }
    
    
}
