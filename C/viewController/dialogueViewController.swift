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
  @IBOutlet var closeButton: UIButton!
  @IBOutlet var classTitleLabelWhenLearn: UILabel!
  @IBOutlet var playButton: UIButton!
  @IBOutlet var stopButton: UIButton!
  
  var progressBar : UIImageView!
  var dialogueData : Array<AnyObject> = Array<AnyObject>()
  var dialogueAttributedData : Array<AnyObject> = Array<AnyObject>()

	let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //dialogueData = jsonData(fileName:"fixedData/199_normal",withExtension:"json").getJSON()
    
    //设定标题
    classTitleLabel.text = " "+appDelegate.syncDataInstance.classTitle+" "
    classTitleLabel.layer.backgroundColor = UIColor.whiteColor().CGColor
    classTitleLabel.layer.opacity = 0.6
    classTitleLabelWhenLearn.text = appDelegate.syncDataInstance.classTitle
    
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
    //tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-1.0))
    self.view.sendSubviewToBack(tableView)
    tableView.tableHeaderView?.backgroundColor = UIColor.whiteColor()
    
    //var tableViewFrame : CGRect = CGRectMake(0.0, self.view.frame.height+50.0, self.view.frame.width, self.view.frame.height-50.0)
    //tableView.frame = tableViewFrame
    //tableView.hidden = true
    
    //tableview背景透明
    tableView.backgroundColor = UIColor.clearColor()
    tableView.backgroundView = nil
    tableView.opaque = false
    
    //设定背景图片
    let backgroundImagePath : String = "images/classBackground/\(appDelegate.syncDataInstance.classIndex).jpg"
    let backgroundImageTempPath : String = "images/classBackground/882.jpg"
    backgroundImageView.image = UIImage(named: backgroundImagePath)
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
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    setDataResource(classIndex : appDelegate.syncDataInstance.classIndex, classMode : appDelegate.syncDataInstance.classMode)
    
    self.dialogueData = self.dialogueAttributedData
    tableView.reloadData()
    
  }
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dialogueData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell : dialogueItemTableViewCell!
    
    if dialogueData[indexPath.row]["send"] as Bool == false
    {
      cell = tableView.dequeueReusableCellWithIdentifier("dialogueItem_left", forIndexPath: indexPath) as dialogueItemTableViewCell
    }
    else
    {
      cell = tableView.dequeueReusableCellWithIdentifier("dialogueItem_right", forIndexPath: indexPath) as dialogueItemTableViewCell
    }
    
    cell.textView.attributedText = dialogueData[indexPath.row]["attributedString"] as NSAttributedString
      //getDialogueContent(data:dialogueData[indexPath.row],textColor : (dialogueData[indexPath.row]["send"].boolValue ? UIColor.whiteColor() : UIColor.blackColor()))
    
    cell.backgroundColor = UIColor.clearColor()
    
    return cell
  }
  
  func setDataResource(#classIndex : String , classMode : String) -> Void {

	  let fileName = "\(classIndex)_\(classMode)"

    //get dialogue data
    let jsonFileName : String = "\(fileName).json"
    let jsonFilePath : String = syncData().dataPath(jsonFileName)
    let data = jsonData(filePath: jsonFilePath).getJSON()
    //处理数据
    var dataArray :Array<AnyObject>= Array<AnyObject>()
    for (index:String,dataItem:JSON) in data
    {
      dataArray.append([
        "send" : dataItem["send"].boolValue,
        "attributedString" : getDialogueContent(data:dataItem,textColor : (dataItem["send"].boolValue ? UIColor.whiteColor() : UIColor.blackColor()))
        ])
    }
    dialogueAttributedData = dataArray
    
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
    titleAni.duration = 0.1
    //self.classTitleLabel.pop_addAnimation(titleAni, forKey: "titleAni")
    
    //模糊动画

    var tableViewBackgroundFrame = self.view.frame
    let tableViewBackground : UIView = UIView(frame: tableViewBackgroundFrame)
    var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight)) as UIVisualEffectView
    visualEffectView.frame = tableViewBackground.bounds
    tableViewBackground.addSubview(visualEffectView)
    self.view.addSubview(tableViewBackground)

    let tableViewBackgroundAni : POPBasicAnimation = POPBasicAnimation()
    tableViewBackgroundAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    tableViewBackgroundAni.property = POPAnimatableProperty.propertyWithName(kPOPViewFrame) as POPAnimatableProperty
    
    tableViewBackgroundFrame.origin.y = self.view.frame.size.height
    tableViewBackgroundAni.fromValue = NSValue(CGRect:tableViewBackgroundFrame)
    tableViewBackgroundAni.name = "tableViewBackgroundAni"
    tableViewBackgroundAni.delegate = self
    tableViewBackgroundAni.duration = 0.2
    tableViewBackground.pop_addAnimation(tableViewBackgroundAni, forKey: "tableViewBackgroundAni")
    
  }
  
  
  
  func pop_animationDidStart(animator : POPAnimation)->Void{
    println("pop_animationDidStart")
  }
  
  func pop_animationDidReachToValue(animator : POPAnimation)->Void{
    println("pop_animationDidReachToValue")
  }
  
  func pop_animationDidStop (animator : POPAnimation, finished : Bool) -> Void {
    println("pop_animationDidStop")
    
    let titleFrame = classTitleLabel.frame
    
    if animator.name == "tableViewBackgroundAni"
    {
      closeButton.imageView?.image = UIImage(named: "close_black")
      self.view.bringSubviewToFront(closeButton)
      self.view.bringSubviewToFront(classTitleLabelWhenLearn)
      self.view.bringSubviewToFront(playButton)
      self.view.bringSubviewToFront(stopButton)
      //sleep(2)
      //self.view.bringSubviewToFront(tableView)
    }
  }
  
  func animatorDidAnimate(animator:POPAnimator)->Void{
    println("pop finished")
  }
  
  func animatorWillAnimate(animator:POPAnimator)->Void{
    println("xxxx")
    
  }
}
