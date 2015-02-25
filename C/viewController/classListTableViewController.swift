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

class classListTableViewController: UITableViewController, UIAlertViewDelegate {

  var classListData : JSON = JSON([])
  let syncDataInstance : syncData = syncData()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "皮蛋英语"
    
    refreshList()
    
    self.refreshControl = UIRefreshControl()
    self.refreshControl?.addTarget(self, action: "refreshList", forControlEvents: UIControlEvents.ValueChanged)
    self.refreshControl?.attributedTitle = NSAttributedString(string: "松开刷新课程")
    self.refreshControl?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    
    //test local notification
    var localNotification:UILocalNotification = UILocalNotification()
    localNotification.alertAction = "皮蛋英语"
    localNotification.alertBody = "今日课程: Traveling Off-Season \n6分钟 150学分"
    localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
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
    let cell : classListTableViewCellType0 = tableView.dequeueReusableCellWithIdentifier("classItemType0", forIndexPath: indexPath) as classListTableViewCellType0
  
    //cell.textLabel?.text = classListData[indexPath.row]["title"].stringValue
    cell.classIndex = classListData[indexPath.row]["id"].stringValue
    cell.title = classListData[indexPath.row]["title"].stringValue
    cell.progress = classListData[indexPath.row]["progress"].doubleValue
  
    if indexPath.row == 0
    {
      cell.isNewClass = true
    }
    else
    {
      cell.isNewClass = false
    }
    
    if indexPath.row == 1
    {
      cell.isLock = true
    }
    else
    {
      cell.isLock = false
    }
    
    return cell
  }

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 250.0
  }
  
  override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
    let cell : classListTableViewCellType0 = sender as classListTableViewCellType0
    if cell.isLock
    {
      let alert : UIAlertView = UIAlertView(title: "课程锁定", message: "昨天没有及时学习，是否解锁？\n 消耗学分：200", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "解锁")
      alert.tag = 0
      alert.show()
      return false
    }
    return true
  }
  
  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    if buttonIndex == 1
    {
      if alertView.tag == 0
      {
        println("积分消费解锁")
        
        let alert : UIAlertView = UIAlertView(title: "积分不足", message: "是否切换至商城兑换学分？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "是")
        alert.tag = 1
        alert.show()
      }
      else if alertView.tag == 1
      {
        println("跳转至商城")
      }
      
    }
  }

  
  func refreshList(){
    let url : String = "http://127.0.0.1:8080/classList.json"  //"http://localhost:3001/app/C/classList.json"
    Alamofire.request(.GET, url).responseJSON {
      
      (_, _, jsonData, _) in
      self.classListData = JSON(jsonData!)
      
      self.tableView.reloadData()
      
      self.refreshControl?.endRefreshing()
      
      //sqlite3 data
      self.syncDataInstance.prepareSQLite3()
      let classesTable = self.syncDataInstance.db["classes"]
      var classesCount : Int = classesTable.count
      if classesCount == 0
      {
        //insert class datas
        for(index : String , subJson : JSON) in self.classListData
        {
          let classId : Int = subJson["id"].intValue
          let classTitle : String = subJson["title"].stringValue
          
          self.syncDataInstance.insertClassList(id: classId, title: classTitle)
          
        }
      }
      
      self.classListData = self.syncDataInstance.getClassListData()
    }
  }
}
