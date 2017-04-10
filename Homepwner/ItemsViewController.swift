//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Nelani Dlamini on 2017/03/14.
//  Copyright © 2017 Nelani Dlamini. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    /*var IndexArray = ["Bedroom","Bathroom","Kitchen","Dining Room", "Living Room", "Garage"]*/
    
    //create an instance of ImageStore to fetch and store images
    var imageStore: ImageStore!
    
    @IBAction func unwindToItemsList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? NewItemController, let item = sourceViewController.item{
            //Add new Item
            let newIndexPath = IndexPath(row: itemStore.allItems.count, section: 0)
        
            itemStore.allItems.append(item)
            
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    //Implement tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    /*override func numberOfSections(in tableView: UITableView) -> Int {
        return IndexArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return IndexArray[section]
    }*/
    
    
    //Implement tableView so that the nth row displays the nth entry in the allItems array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        //create an instance of UITableViewCell, with default appearance
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        //set the text on the cell with the description of the item
        //that is at the nth index of items, where n = row this cell will appear in on the tableview
        let item = itemStore.allItems[indexPath.row]
        
        //Configure the cell with the Item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        //Update ItemCell to display the valueInDollars in green if the value is less than 50 and red if the value is greater than or equal to 50
        if item.valueInDollars >= 50 {
           cell.valueLabel.textColor = UIColor.red
        } else {
            cell.valueLabel.textColor = UIColor.green
        }
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //If the table view is asking to commit a delete command
        if editingStyle == .delete{
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) -> Void in
            
            //remove the item from the store
            self.itemStore.removeItem(item)
                
            //Remove the item's image from the image store
            self.imageStore.deleteImage(forKey: item.itemKey)
            
            //Also remove that row from the table view with an animation 
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        ac.addAction(deleteAction)
            present(ac,animated: true, completion: nil)
        }
    }
    
    //implement method to update the store
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    //implement method to allow the view controllers to share data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem"?:
            //Figure our which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row{
                //Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        case "newItem"?: break
        default:
            preconditionFailure("Unexpected segue identifier.")

            
            }
        }
    //override viewwillappear so the user can immediately see changes made to Item
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
}
