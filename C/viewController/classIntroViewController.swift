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
  @IBOutlet var startButton: UIButton!
  @IBOutlet var classTitle: UILabel!
  @IBOutlet var classDescription: UITextView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    backgroundImage.image = UIImage(named: "images/classBackground/586.jpg")
    
    startButton.layer.backgroundColor = UIColor(white: 1.0, alpha: 0.2).CGColor
    startButton.layer.borderColor = UIColor.whiteColor().CGColor
    startButton.layer.borderWidth = 1.0
    startButton.layer.cornerRadius = 5.0
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  @IBAction func closeClass(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}
