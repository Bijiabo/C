//
//  shopViewController.swift
//  C
//
//  Created by bijiabo on 15/2/26.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import UIKit

class shopViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "shop"
    
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("goodsItem", forIndexPath: indexPath) as UITableViewCell
    
    return cell
  }
  
  @IBAction func closeShop(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}
