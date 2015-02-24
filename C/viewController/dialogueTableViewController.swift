//
//  dialogueTableViewController.swift
//  C
//
//  Created by bijiabo on 15/2/25.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import UIKit
import SwiftyJSON

class dialogueTableViewController: UITableViewController {

	var dialogueData : JSON = JSON([])

  override func viewDidLoad() {
    super.viewDidLoad()

	  dialogueData = jsonData(fileName:"fixedData/199_normal",withExtension:"json").getJSON()
    
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dialogueData.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if dialogueData[indexPath.row]["role"].stringValue == "Vicky"
    {
      let cell = tableView.dequeueReusableCellWithIdentifier("dialogueItem_left", forIndexPath: indexPath) as dialogueItemTableViewCell_left
      
      cell.contentText = dialogueData[indexPath.row]["content"].stringValue
      
      return cell
    }
    else
    {
      let cell = tableView.dequeueReusableCellWithIdentifier("dialogueItem_right", forIndexPath: indexPath) as dialogueItemTableViewCell_right
      
      cell.textView.text = dialogueData[indexPath.row]["content"].stringValue
      
      return cell
    }
    
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
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  }
  */
  
}
