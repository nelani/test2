//
//  NewItemController.swift
//  Homepwner
//
//  Created by Nelani Dlamini on 2017/04/09.
//  Copyright © 2017 Nelani Dlamini. All rights reserved.
//

import UIKit
import os.log


class NewItemController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var dateCreated: UITextField!
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //This value is either passed by ItemsViewController in prepare(for:sender:) or constructed when adding a new item
    var item: Item?
    

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem){
        let imagePicker = UIImagePickerController()
        
        //If the device has a camera, take a picture; otherwise,
        //pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        }else{
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        //Place image picker on the screen
        present(imagePicker, animated: true, completion: nil)
    }
    
    let locationOptions = ["Bedroom","Bathroom","Kitchen","Dining Room", "Living Room", "Garage"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locationOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        location.text = locationOptions[row]
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        
        dateCreated.text = formatter.string(from: sender.date)
    }

    
    //method to configure a view controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        //configure the destination view controller only when save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameField.text ?? ""
        let serialNumber = serialNumberField.text ?? ""
        //let value = valueField.text
        let valueInDollars = 0
        let location = self.location.text ?? ""
        
        //set the item to be passed to ItemsViewController after the unwind segue
        item = Item(name: name, serialNumber: serialNumber, valueInDollars: valueInDollars, location: location)
    }
    
   func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the save button while editing
        saveButton.isEnabled = false
        
    }
    
    private func updateSaveButtonState(){
        //Disable the save button if the text field is empty.
        let nameText = nameField.text ?? ""
        //let valueText = valueField.text ?? ""
        
        /*if (!nameText.isEmpty && !valueText.isEmpty) {
            saveButton.isEnabled = true
        }*/
        saveButton.isEnabled = !nameText.isEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        item?.dataCreated = Date()
        
        //Handle the text fields user input through delegate callbacks.
        nameField.delegate = self
        
        //Enable the save button only if the text field has a valid item name
        updateSaveButtonState()
        
        let theLocationPicker = UIPickerView()
        location.inputView = theLocationPicker
        
        theLocationPicker.delegate = self
        
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(DetailViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        dateCreated.inputView = datePicker
    }
    
}
