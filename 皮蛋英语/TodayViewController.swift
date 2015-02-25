//
//  TodayViewController.swift
//  皮蛋英语
//
//  Created by bijiabo on 15/2/25.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
    
    completionHandler(NCUpdateResult.NewData)
  }
  
}
