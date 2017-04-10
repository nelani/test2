//
//  Item.swift
//  Homepwner
//
//  Created by Nelani Dlamini on 2017/03/14.
//  Copyright © 2017 Nelani Dlamini. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
    
    //Define the Item class
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dataCreated: Date
    let itemKey: String
    
    //Implement a new designated initializer on the Item class that set the initial values for all the properties
    init(name: String, serialNumber: String?, valueInDollars: Int){
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dataCreated = Date()
        self.itemKey = UUID().uuidString
        
        super.init()
    }
    
    //Add a convenience initializer to Item that creates a randomly generated item
    convenience init(random: Bool = false){
        if random{
        self.init(name: "", serialNumber: nil, valueInDollars: 0)
        } else{
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
    
    //Implement a method to add names and values of the item's properties to the stream
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(dataCreated, forKey: "dataCreated")
        aCoder.encode(itemKey, forKey: "itemKey")
        aCoder.encode(serialNumber, forKey: "serialNumber")
        
        aCoder.encode(valueInDollars, forKey: "serialNumber")
    }
    
    //Implement method to grab all the objects that were encoded in ecode(with:) and assign to the approriate property
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        dataCreated = aDecoder.decodeObject(forKey: "dataCreated") as! Date
        itemKey = aDecoder.decodeObject(forKey: "itemKey") as! String
        serialNumber = aDecoder.decodeObject(forKey: "serialNumber") as! String?
        
        valueInDollars = aDecoder.decodeInteger(forKey: "valueInDollars")
        
        super.init()
    }
    
    
}
