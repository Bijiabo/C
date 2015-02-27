//
//  classListTableViewCellType0.swift
//  C
//
//  Created by bijiabo on 15/2/21.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import UIKit

class classListTableViewCellType0: UITableViewCell {
  
  @IBOutlet var previewImage: UIImageView!
  @IBOutlet var starLabel: UILabel!
  @IBOutlet var classTitle: UILabel!
  @IBOutlet var shadowImage: UIImageView!
  @IBOutlet var newClassIcon: UIImageView!
  @IBOutlet var lockIcon: UIImageView!
  @IBOutlet var blackShadow: UIImageView!
  
  var isNewClass : Bool = false{
    didSet {
      if isNewClass
      {
        newClassIcon.image = UIImage(named: "images/classlist/newClass")
      }
      else
      {
        newClassIcon.image = UIImage()
      }
    }
  }
  
  var isLock : Bool = false {
    didSet {
      if isLock
      {
        lockIcon.image = UIImage(named: "images/classlist/lock")
        blackShadow.layer.opacity = 0.3
      }
      else
      {
        lockIcon.image = UIImage()
        blackShadow.layer.opacity = 0.0
      }
    }
  }
  
  var classIndex : String! {
    didSet {
      previewImage.image = UIImage(named: "images/classlist/preview/\(classIndex).jpg")
    }
  }
  
  var title : String = ""{
    didSet {
      classTitle.text = title
    }
  }
  
  var progress : Double = 0.0 {
    didSet{
      starLabel.textColor = UIColor(red: 236/255, green: 186/255, blue: 16/255, alpha: 1.0)
      if progress>0.9
      {
        starLabel.text = "★★★"
      }
      else if progress>0.6
      {
        starLabel.text = "★★☆"
      }
      else if progress>=0.1
      {
        starLabel.text = "★☆☆"
      }
      else
      {
        starLabel.text = "☆☆☆"
        starLabel.textColor = UIColor.grayColor()
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    shadowImage.image = UIImage(named: "images/classlist/shadow.png")
    blackShadow.backgroundColor = UIColor.blackColor()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
