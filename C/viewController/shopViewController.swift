//
//  shopViewController.swift
//  C
//
//  Created by bijiabo on 15/2/26.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import UIKit
import GCD

class shopViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

  var shopInstance : shop!
  var refreshControl : UIRefreshControl!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var headerBackgroundImageView: UIImageView!
  var indicator: MaterialActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    headerBackgroundImageView.backgroundColor = UIColor(red:0.96, green:0.97, blue:0.95, alpha:1)
    
    self.title = "Shop"
    
    tableView.estimatedRowHeight = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).lineHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    
    shopInstance = shop(shopVC: self)
    /*
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "handleRefresh", forControlEvents: UIControlEvents.ValueChanged)
    tableView.addSubview(refreshControl)
    
    refreshControl.beginRefreshing()
    */
    
    gcd.async(.Main) {
      self.indicator = MaterialActivityIndicatorView(style: .Large)
      self.indicator.center = self.view.center
      self.view.addSubview(self.indicator)
      self.indicator.startAnimating()
    }

    
    
  }
  
  func handleRefresh() -> Void {
    
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    
    shopInstance.removeTransactionObserver()
  }
  
  func didGetProductsList() -> Void{
    println("didGetProductsList")
    //refreshControl.endRefreshing()
    
    gcd.async(.Main) {
      self.indicator.stopAnimating()
    }
    
    if shopInstance.products.count>0
    {
      var indexPaths : [AnyObject] = []
      for i in 0...(shopInstance.products.count - 1)
      {
        indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
      }
      tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Right)
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shopInstance.products.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell : goodsItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("goodsItem", forIndexPath: indexPath) as goodsItemTableViewCell
    
    cell.goodTitle.text = shopInstance.products[indexPath.row]["title"] as String!
    cell.goodPrice.text = shopInstance.products[indexPath.row]["priceString"] as String!
    
    return cell
  }
  
  @IBAction func closeShop(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}
