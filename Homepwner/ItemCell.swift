//
//  ItemCell.swift
//  Homepwner
//
//  Created by Nelani Dlamini on 2017/03/14.
//  Copyright © 2017 Nelani Dlamini. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    //override awakeFromNib to have the labels automatically adjust
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.adjustsFontForContentSizeCategory = true
        serialNumberLabel.adjustsFontForContentSizeCategory = true
        valueLabel.adjustsFontForContentSizeCategory = true
        
    }
    
}
