//
//  NewItemViewController.swift
//  ios-mini-app-braeburn
//
//  Created by Matthew Leon on 10/5/16.
//  Copyright © 2016 CS4720. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var itemDescriptionTextField: UITextField!
    @IBOutlet weak var itemCompletedSwitch: UISwitch!
    
    var isCompleted = false;

    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Add button while editing
        addButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidItemName()
        navigationItem.title = itemTextField.text
    }
    
    func checkValidItemName() {
        // Disable Add button if the text field is empty.
        let text = itemTextField.text ?? ""
        addButton.isEnabled = !text.isEmpty
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddItemMode = presentingViewController is UINavigationController
        if isPresentingInAddItemMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }        
    }

    // method to let you configure a view controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let sender = sender as? UIBarButtonItem, sender === addButton {
            let itemName = itemTextField.text ?? ""
            let itemDescription = itemDescriptionTextField.text ?? ""
            print(isCompleted)
            let itemCompletedSwitch = isCompleted
                
            // Set the item to be passed to ItemTableViewController after unwind segue
            item = Item(name: itemName, desc: itemDescription, isCompleted: isCompleted)
        }
    }
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks
        itemTextField.delegate = self
        
        if let item = item {
            navigationItem.title = item.name
            itemTextField.text = item.name
            itemDescriptionTextField.text = item.desc
            itemCompletedSwitch.setOn(item.isCompleted, animated: false)
            isCompleted = item.isCompleted
        }
        
        // Enable the add button only if the text field has a valid item name
        checkValidItemName()

        
        itemCompletedSwitch.addTarget(self, action: #selector(NewItemViewController.completedSwitchChanged(_:)), for: UIControlEvents.valueChanged)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Actions
    
    func completedSwitchChanged(_ itemSwitch: UISwitch) {
        if isCompleted == false {
            isCompleted = true;
        } else {
            isCompleted = false;
        }
    }
    
    
    

}
