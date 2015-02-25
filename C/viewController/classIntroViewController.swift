//
//  classIntroViewController.swift
//  C
//
//  Created by bijiabo on 15/2/25.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import UIKit

class classIntroViewController: UIViewController {
  
  @IBOutlet var backgroundImage: UIImageView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    backgroundImage.image = UIImage(named: "images/classBackground/586.jpg")

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  @IBAction func closeClass(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}
