//
//  DateCreatedViewController.swift
//  Homepwner
//
//  Created by Nelani Dlamini on 2017/04/10.
//  Copyright © 2017 Nelani Dlamini. All rights reserved.
//

import UIKit

class DateCreatedViewController: UIViewController {
    var datePicker: UIDatePicker!
    var item: Item!
    
    
    //      override func loadView() {
    //        super.loadView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Date Created"
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(datePicker)
        
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    //create a formatter to print the date
    let dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = dateFormatter.string(from: datePicker.date)
    }
}
