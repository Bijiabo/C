//
//  dialogueViewController.swift
//  C
//
//  Created by bijiabo on 15/2/27.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import AVFoundation
import pop

class dialogueViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, POPAnimatorDelegate{


	@IBOutlet var tableView: UITableView!
  @IBOutlet var classTitleLabel: UILabel!
  @IBOutlet var backgroundImageView: UIImageView!
  
  var dialogueData : JSON = JSON([])
  var progressBar : UIImageView!

	let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //dialogueData = jsonData(fileName:"fixedData/199_normal",withExtension:"json").getJSON()

    //设定标题
    classTitleLabel.text = " "+appDelegate.syncDataInstance.classTitle+" "
    classTitleLabel.layer.backgroundColor = UIColor.whiteColor().CGColor
    classTitleLabel.layer.opacity = 0.5
    
	  //set views
    let headerBarHeight : CGFloat = 50.0
    
    let blurUIView : UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.height, headerBarHeight))
    
    var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight)) as UIVisualEffectView
    visualEffectView.frame = blurUIView.bounds
    blurUIView.layer.shadowColor = UIColor.blackColor().CGColor
    blurUIView.layer.shadowOffset = CGSizeMake(0.0, 1.0)
    blurUIView.layer.shadowRadius = 2.0
    blurUIView.layer.shadowOpacity = 0.2
    blurUIView.addSubview(visualEffectView)
    
    self.view.addSubview(blurUIView)
    self.view.sendSubviewToBack(blurUIView)
    
    tableView.estimatedRowHeight = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).lineHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, headerBarHeight))
    self.view.sendSubviewToBack(tableView)
    var tableViewFrame : CGRect = CGRectMake(0.0, self.view.frame.height+50.0, self.view.frame.width, self.view.frame.height-50.0)
    tableView.frame = tableViewFrame
    tableView.hidden = true
    
    //tableview背景透明
    tableView.backgroundColor = UIColor.clearColor()
    tableView.backgroundView = nil
    tableView.opaque = false
    
    //设定背景图片
    let backgroundImagePath : String = "images/classBackground/\(appDelegate.syncDataInstance.classIndex).jpg"
    let backgroundImageTempPath : String = "images/classBackground/882.jpg"
    backgroundImageView.image = UIImage(named: backgroundImageTempPath)
    //self.view.sendSubviewToBack(backgroundImageView)
    
    //添加进度条
    let progressBarHeight : CGFloat = 1.5
    
    /*
    let progressBarBackgroundView : UIImageView = UIImageView(frame: CGRectMake(0, headerBarHeight - progressBarHeight , self.view.frame.size.width, progressBarHeight ))
    progressBarBackgroundView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1)
    self.view.addSubview(progressBarBackgroundView)
    */
    
    progressBar = UIImageView(frame: CGRectMake(0, headerBarHeight - progressBarHeight , 1.0, progressBarHeight ))
    progressBar.backgroundColor = UIColor(red:0.12, green:0.58, blue:1, alpha:1)
    self.view.addSubview(progressBar)
  }
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dialogueData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell : dialogueItemTableViewCell!
    
    if dialogueData[indexPath.row]["send"].boolValue == false
    {
      cell = tableView.dequeueReusableCellWithIdentifier("dialogueItem_left", forIndexPath: indexPath) as dialogueItemTableViewCell
    }
    else
    {
      cell = tableView.dequeueReusableCellWithIdentifier("dialogueItem_right", forIndexPath: indexPath) as dialogueItemTableViewCell
    }
    
    cell.textView.attributedText = getDialogueContent(data:dialogueData[indexPath.row],textColor : (dialogueData[indexPath.row]["send"].boolValue ? UIColor.whiteColor() : UIColor.blackColor()))
    
    cell.backgroundColor = UIColor.clearColor()
    
    return cell
  }
  
  func setDataResource(#classIndex : String , classMode : String) -> Void {

	  let fileName = "\(classIndex)_\(classMode)"

    //get dialogue data
    let jsonFileName : String = "\(fileName).json"
    let jsonFilePath : String = syncData().dataPath(jsonFileName)
    dialogueData = jsonData(filePath: jsonFilePath).getJSON()
    
    //set player
    let mediaFileName : String = "\(fileName).m4a"
    let mediaFilePath : String = syncData().dataPath(mediaFileName)

    appDelegate.player.setPlayerByPath(mediaFilePath)
    
    //同步进度条
    //TODO : 音频结束后移除observer
    let intervalTime : CMTime = CMTimeMake(1000,1000)
    appDelegate.player.addPeriodicTimeObserverToPlayer(name: "progressBar", interval: intervalTime , usingBlock: {(timeNow:CMTime) -> Void in
      let secondsNow = CMTimeGetSeconds(timeNow)
      let playerDuration = CMTimeGetSeconds(self.appDelegate.player.player.currentItem.asset.duration)
      
      var frame = self.progressBar.frame
      frame.size.width = CGFloat(secondsNow / playerDuration) * self.view.frame.size.width
      
      let progressAnimation : POPBasicAnimation = POPBasicAnimation()
      progressAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
      progressAnimation.property = POPAnimatableProperty.propertyWithName(kPOPViewFrame) as POPAnimatableProperty
      progressAnimation.toValue = NSValue(CGRect:frame)
      progressAnimation.name = "progressAni"
      progressAnimation.delegate = self
      progressAnimation.duration = 1.5
      self.progressBar.pop_addAnimation(progressAnimation, forKey: "progressAni")
      //self.progressBar.frame = frame
    })
    
    //appDelegate.player.player.play()

  }

  func getDialogueContent(#data : JSON , textColor : UIColor) -> NSMutableAttributedString {
		var dialogueContent : NSMutableAttributedString = NSMutableAttributedString(string: "")
		if data["text"].arrayValue.count>0
		{
			for (key : String , dataItem : JSON) in data["text"]
			{
        //记录单词边界
        let range : NSRange = NSMakeRange(dialogueContent.length, dataItem["text"].stringValue.utf16Count)
        
        //加粗
        var StrokeWidth = "0"
        if data["keywords"].arrayValue.count>0
        {
          for (index : String , keywordsItem : JSON) in data["keywords"]
          {
            if dataItem["index"].intValue>=keywordsItem["range"][0]["start"].intValue && dataItem["index"].intValue<=keywordsItem["range"][0]["end"].intValue
            {
              StrokeWidth = "-2"
            }
          }
        }
        
        dialogueContent.appendAttributedString(
          NSAttributedString(string: dataItem["text"].stringValue,attributes: [
            "type" : dataItem["type"].stringValue,
            NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody),
            NSForegroundColorAttributeName:textColor,
            NSStrokeWidthAttributeName : StrokeWidth,
            "range" : range
            ]))
			}
      
		}
		
    return dialogueContent
	}

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func closePage(sender: AnyObject) {
    
    self.dismissViewControllerAnimated(true, completion: nil)
    //移除所有 present modal
    //self.presentingViewController!.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    
    //appDelegate.player.player.pause()
  }
  
  @IBAction func startClass(sender: AnyObject) {
    
    //开始课程
    
    //标题动画
    let titleAni : POPBasicAnimation = POPBasicAnimation()
    titleAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    titleAni.property = POPAnimatableProperty.propertyWithName(kPOPViewFrame) as POPAnimatableProperty
    var titleFrame : CGRect = classTitleLabel.frame
    titleFrame.origin = CGPointMake(8.0, 16.0)
    titleAni.toValue = NSValue(CGRect:titleFrame)
    titleAni.name = "titleAni"
    titleAni.delegate = self
    titleAni.duration = 0.5
    self.classTitleLabel.pop_addAnimation(titleAni, forKey: "titleAni")
    
    //tableview 动画
    self.tableView.hidden = false
    self.view.bringSubviewToFront(tableView)
    let tableViewAni : POPBasicAnimation = POPBasicAnimation()
    tableViewAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    tableViewAni.property = POPAnimatableProperty.propertyWithName(kPOPViewFrame) as POPAnimatableProperty
    var tableViewFrame : CGRect = CGRectMake(0.0, 50.0, self.view.frame.width, self.view.frame.height-50.0)
    tableViewAni.toValue = NSValue(CGRect:tableViewFrame)
    tableViewAni.name = "tableViewAni"
    tableViewAni.delegate = self
    tableViewAni.duration = 0.5
    //tableView.pop_addAnimation(tableViewAni, forKey: "tableViewAni")
    
    
  }
  
  func pop_animationDidStart(#anim : POPAnimation)->Void{
    println("cccc")
  }
  
  func pop_animationDidReachToValue(#anim : POPAnimation)->Void{
    println("vvvv")
  }
  
  func pop_animationDidStop (#anim : POPAnimation, _ finished : Bool) -> Void {
    println("aaaa")
  }
  
  func animatorDidAnimate(animator:POPAnimator)->Void{
    println("pop finished")
    //setDataResource(classIndex : appDelegate.syncDataInstance.classIndex, classMode : appDelegate.syncDataInstance.classMode)
  }
  
  func animatorWillAnimate(animator:POPAnimator)->Void{
    println("xxxx")
    
  }
}
