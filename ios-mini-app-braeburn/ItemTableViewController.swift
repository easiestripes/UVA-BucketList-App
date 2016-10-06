//
//  ItemTableViewController.swift
//  ios-mini-app-braeburn
//
//  Created by Matthew Leon on 9/26/16.
//  Copyright © 2016 CS4720. All rights reserved.
/**
 * Sources: 
 * https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson7.html#//apple_ref/doc/uid/TP40015214-CH8-SW1
 * http://stackoverflow.com/questions/24215117/how-to-recognize-swipe-in-all-4-directions
 */
import UIKit

class ItemTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    
    var items = [Item]()
    var currentCell:ItemTableViewCell?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDefaultItems()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = .right
        swipeRight.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeLeft)
    }

    func swiped(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            let loc = swipeGesture.location(in: self.tableView)
            let indexPath = tableView.indexPathForRow(at: loc)
            if(indexPath != nil) {
                currentCell = tableView.cellForRow(at: indexPath!) as? ItemTableViewCell
            }
            
            if (currentCell) != nil {
                
                switch swipeGesture.direction {
                    
                case UISwipeGestureRecognizerDirection.right:
                    currentCell?.accessoryType = UITableViewCellAccessoryType.checkmark
                    let ind = tableView.indexPath(for: currentCell!)
                    items[(ind?.row)!].isCompleted = true
                   // tableView.reloadRows(at: [indexPath!], with: .none)
                    currentCell = nil
                    
                case UISwipeGestureRecognizerDirection.left:
                    currentCell?.accessoryType = UITableViewCellAccessoryType.none
                    let ind = tableView.indexPath(for: currentCell!)
                    items[(ind?.row)!].isCompleted = false
                   // tableView.reloadRows(at: [indexPath!], with: .none)
                    //tableView.cellAt(indexPath) = currentCell
                   // tableView.cellAt
                    currentCell = nil
                    
                default:
                    break
                }
            }
        }
    }
    
    func loadDefaultItems() {
        let item1 = Item(name: "Streak The Lawn", desc: "Goodnight, Mr. Jefferson", isCompleted: false)
        let item2 = Item(name: "Go Steamtunneling", desc: "it's hot", isCompleted: false)
        let item3 = Item(name: "High-Five Dean Groves", desc: "cool!", isCompleted: false)
        
        items += [item1, item2, item3]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ItemTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ItemTableViewCell
        let item = items[indexPath.row]
        
        cell.nameLabel.text = item.name
        
        return cell
    }
    
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewItemViewController, let item = sourceViewController.item {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // update an existing item
                items[selectedIndexPath.row] = item
                print(item.isCompleted)
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                if item.isCompleted == true{
                    print("1")
                    let temp = tableView.cellForRow(at: selectedIndexPath) as? ItemTableViewCell
                    temp?.accessoryType = UITableViewCellAccessoryType.checkmark
                    //tableView.cellForRow(at: <#T##IndexPath#>)
                    //currentCell = tableView.cellForRow(at: indexPath!) as? ItemTableViewCell
                } else {
                    print("2")
                    let temp = tableView.cellForRow(at: selectedIndexPath) as? ItemTableViewCell
                    temp?.accessoryType = UITableViewCellAccessoryType.checkmark
                    //currentCell?.accessoryType = UITableViewCellAccessoryType.none
                }
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new item.
                let newIndexPath = IndexPath(row: items.count, section: 0)
                items.append(item)
                if item.isCompleted == true{
                    currentCell?.accessoryType = UITableViewCellAccessoryType.checkmark
                    tableView.insertRows(at: [newIndexPath], with: .bottom)
                }
                else{
                    currentCell?.accessoryType = UITableViewCellAccessoryType.none
                    tableView.insertRows(at: [newIndexPath], with: .bottom)
                }
            }
        }
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let itemDetailViewController = segue.destination as! NewItemViewController
            // Get the cell that generated this segue
            if let selectedItemCell = sender as? ItemTableViewCell {
                let indexPath = tableView.indexPath(for: selectedItemCell)!
                let selectedItem = items[indexPath.row]
                itemDetailViewController.item = selectedItem
            }
        }
        else if segue.identifier == "AddItem"{
            
     }
    
    }
}
