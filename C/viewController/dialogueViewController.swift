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

class dialogueViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{


	@IBOutlet var tableView: UITableView!
  var dialogueData : JSON = JSON([])
  var progressBar : UIImageView!

	let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //dialogueData = jsonData(fileName:"fixedData/199_normal",withExtension:"json").getJSON()
		setDataResource(classIndex : appDelegate.syncDataInstance.classIndex, classMode : appDelegate.syncDataInstance.classMode)


	  //set views
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

    //添加进度条
    let progressBarHeight : CGFloat = 3.0
    progressBar = UIImageView(frame: CGRectMake(0, headerBarHeight - progressBarHeight , 1.0, progressBarHeight ))
    progressBar.backgroundColor = UIColor(red:0.66, green:0.93, blue:0.41, alpha:1)
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
      println(frame.size.width)
      self.progressBar.frame = frame
    })
    
    appDelegate.player.player.play()

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
    //移除所有 present modal
    self.presentingViewController!.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    
    appDelegate.player.player.pause()
  }
  
  
}
