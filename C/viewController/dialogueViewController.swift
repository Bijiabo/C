//
//  dialogueViewController.swift
//  C
//
//  Created by bijiabo on 15/2/27.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import UIKit
import SwiftyJSON

class dialogueViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
  
  @IBOutlet var tableView: UITableView!
  var dialogueData : JSON = JSON([])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dialogueData = jsonData(fileName:"fixedData/199_normal",withExtension:"json").getJSON()
    
    let headerBarHeight : CGFloat = 50.0
    
    let blurUIView : UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, headerBarHeight))
    
    var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
    visualEffectView.frame = blurUIView.bounds
    blurUIView.addSubview(visualEffectView)
    
    self.view.addSubview(blurUIView)
    self.view.sendSubviewToBack(blurUIView)
    
    tableView.estimatedRowHeight = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).lineHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    
    tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, headerBarHeight))
    
    self.view.sendSubviewToBack(tableView)
  }
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dialogueData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell : dialogueItemTableViewCell!
    
    if dialogueData[indexPath.row]["role"].stringValue == "Vicky"
    {
      cell = tableView.dequeueReusableCellWithIdentifier("dialogueItem_left", forIndexPath: indexPath) as dialogueItemTableViewCell
      
      cell.isLeft = true
    }
    else
    {
      cell = tableView.dequeueReusableCellWithIdentifier("dialogueItem_right", forIndexPath: indexPath) as dialogueItemTableViewCell
      
      cell.isLeft = false
    }
    
    cell.contentText = dialogueData[indexPath.row]["content"].stringValue
    
    return cell
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}
