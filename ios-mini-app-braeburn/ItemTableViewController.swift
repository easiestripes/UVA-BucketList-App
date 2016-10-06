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
        
        /*let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
         swipeDown.direction = .down
         swipeDown.numberOfTouchesRequired = 1
         self.view.addGestureRecognizer(swipeDown)
         
         let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
         swipeUp.direction = .up
         swipeUp.numberOfTouchesRequired = 1
         self.view.addGestureRecognizer(swipeUp)*/
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = .right
        swipeRight.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeLeft)
        /*
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
 */
    }
/*
    func tapped(gesture: UIGestureRecognizer) {
        if let tapGesture = gesture as? UITapGestureRecognizer {
            let loc = tapGesture.location(in: self.tableView)
            let indexPath = tableView.indexPathForRow(at: loc)
            if(indexPath != nil) {
                currentCell = tableView.cellForRow(at: indexPath!) as? ItemTableViewCell
            }
            if (currentCell) != nil {
                print (currentCell?.nameLabel.text, "touched")
            }
        }
    }
    */
    
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
                    //print("Swiped Right")
                    currentCell?.accessoryType = UITableViewCellAccessoryType.checkmark
                    print(currentCell)
                    currentCell = nil
                    
                case UISwipeGestureRecognizerDirection.left:
                    //print("Swiped Left")
                    currentCell?.accessoryType = UITableViewCellAccessoryType.none
                    currentCell = nil
                    
                    /*case UISwipeGestureRecognizerDirection.up:
                     //print("Swiped Up")
                     
                     case UISwipeGestureRecognizerDirection.down:
                     //print("Swiped Down")*/
                    
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
    
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
     //let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
     print("test")
     if(indexPath != nil) {
     currentCell = tableView.cellForRow(at: indexPath) as! ItemTableViewCell
     print(indexPath.row)
     } else {
     print("pickles")
     }
     }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    /*func getIndexPathFromCell(sender: UIButton) -> NSIndexPath! {
     if let view = sender.superview {
     var superView = view
     while (!superView.isKindOfClass(UITableViewCell.classForCoder())) {
     if let viewSuperView = superView.superview {
     superView = viewSuperView
     } else {
     return nil
     }
     }
     if let cell = superView as? GoalsTableViewCell {
     return myTableView.indexPathForCell(cell)
     } else {
     return nil
     }
     } else {
     return nil
     }
     }*/
    
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
    
    
    /*
    @IBAction func unwindToItemList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? NewItemViewController, item = sourceViewController.item {
            // Add a new item
            let newIndexPath = NSIndexPath(forRow: items.count, inSection: 0)
            items.append(item)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            
        }
    }
 */
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewItemViewController, let item = sourceViewController.item {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // update an existing item
                items[selectedIndexPath.row] = item
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new item.
                let newIndexPath = IndexPath(row: items.count, section: 0)
                items.append(item)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
        }
    }

    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
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
