//
//  classListTableViewController.swift
//  C
//
//  Created by bijiabo on 15/2/21.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class classListTableViewController: UITableViewController {

  var classListData : JSON = JSON([])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "C.List"
    
    refreshList()
    
    self.refreshControl = UIRefreshControl()
    self.refreshControl?.addTarget(self, action: "refreshList", forControlEvents: UIControlEvents.ValueChanged)
    self.refreshControl?.attributedTitle = NSAttributedString(string: "松开刷新课程")
    self.refreshControl?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
  }
  
  override func viewWillAppear(animated: Bool) {
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return classListData.count
  }
  

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("classItemType0", forIndexPath: indexPath) as UITableViewCell
  
    cell.textLabel?.text = classListData[indexPath.row]["title"].stringValue
  
    return cell
  }

  
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return NO if you do not want the specified item to be editable.
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
  // Return NO if you do not want the item to be re-orderable.
  return true
  }
  */
  
  func refreshList(){
    Alamofire.request(.GET, "http://localhost:3001/app/C/classList.json").responseJSON {
      
      (_, _, jsonData, _) in
      self.classListData = JSON(jsonData!)
      
      self.tableView.reloadData()
      
      self.refreshControl?.endRefreshing()
    }
  }
}
