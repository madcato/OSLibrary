//
//  OSEditableTableViewController.swift
//  mavlink
//
//  Created by Daniel Vela on 26/06/16.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import UIKit

protocol OSDataSource {
    func count() -> Int
    func get(index: Int) -> String
    func put(element: String, at: Int)
    func insert(element: String, at: Int)
    func post(element: String)
    func removeAtIndex(index: Int)
}

// Sample 
//class TestData: NSObject, OSDataSource {
//    
//    var data:[String]
//    override init() {
//        data = []
//        data.append("Hola")
//        data.append("Hola1")
//        data.append("Hola2")
//        data.append("Hola3")
//        data.append("Adios")
//        super.init()
//    }
//    
//    func count() -> Int {
//        return data.count
//    }
//    
//    func get(index: Int) -> String {
//        return data[index]
//    }
//    
//    func put(element: String, at: Int) {
//        data[at] = element
//    }
//    
//    func insert(element: String, at: Int) {
//        data.insert(element, atIndex: at)
//    }
//    
//    func post(element: String) {
//        data.append(element)
//    }
//    
//    func removeAtIndex(index: Int) {
//        data.removeAtIndex(index)
//    }
//}


class OSEditableTableViewController: UITableViewController {

    var dataSource: OSDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        dataSource = TestData()
    }

    
    @IBAction func insertPressed(sender: AnyObject) {
        let row = self.tableView(self.tableView, numberOfRowsInSection: 0)
        dataSource?.post("newElement")
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let count = dataSource?.count() {
            return count
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FileTableCell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = dataSource?.get(indexPath.row)

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            dataSource?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }


    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if let data = dataSource?.get(fromIndexPath.row) {
            dataSource?.removeAtIndex(fromIndexPath.row)
            dataSource?.insert(data, at: toIndexPath.row)
        }
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
