//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Nelani Dlamini on 2017/03/22.
//  Copyright © 2017 Nelani Dlamini. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Add new outlets and make connections
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var dateCreated: UITextField!
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theLocationPicker = UIPickerView()
        location.inputView = theLocationPicker
        
        theLocationPicker.delegate = self
        
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(DetailViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        dateCreated.inputView = datePicker
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //create a reference to the Item that is being displayed.
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    

    //create an instance of ImageStore to fetch and store images
    var imageStore: ImageStore!
    
    //create a formatter to print the value in dollars
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    
    //create a formatter to print the date
    let dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    //override viewWillAppear to set up interface to show the text to the appropriate values
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        location.text = item.location
        //dateCreated.text = item.dataCreated
      
        
        //Get the item key
        let key = item.itemKey
        
        //If there is an associated image with the item display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Clear first responder
        view.endEditing(true)
        
        //"save" changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        item.location = location.text
        //item.dataCreated = dateCreated.text
        
        if let valueText = valueField.text,
            let value = numberFormatter.number(from: valueText){
            item.valueInDollars = value.intValue
        }else{
            item.valueInDollars = 0
        }
    }
    
   //Implement textfieldShouldReturn to call resignFirstResponder on the text field that is passed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //function to put the image in UIImageView and call the method to dismiss the image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
    
        //Get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
    
        //Put that image on the screen in the image view
        imageView.image = image
    
        //Take image picker off the screen - 
        //You must call this dismiss method 
    dismiss(animated: true, completion: nil)
    }
    
}
