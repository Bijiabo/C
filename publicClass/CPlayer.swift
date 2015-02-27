//
// Created by bijiabo on 15/2/27.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

class CPlayer : NSObject{
	var player : AVPlayer!
  var playerObserverDictionary : Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

	//set media for player
	func setPlayer(fileName : String, withExtension : String) -> Void {
		let audioURL : NSURL = NSBundle.mainBundle().URLForResource(fileName, withExtension: withExtension)!
		player = AVPlayer(URL: audioURL)

	}

	func setPlayerByPath(filePath : String) -> Void {
		let fileURL : NSURL! = NSURL.fileURLWithPath(filePath)
		player = AVPlayer(URL: fileURL)
	}

	func makeCMTimeArray(#timeArray : [Int]) -> Void {
		var CMTimeArray : [CMTime] = []
		for timeItem in timeArray
		{
			CMTimeArray.append(CMTimeMake(Int64(timeItem), 1000))
		}
	}

  func addBoundaryTimeObserverToPlayer(#name : String ,times : [AnyObject] , usingBlock : () -> Void ) -> Void {
    playerObserverDictionary[name] = player.addBoundaryTimeObserverForTimes(times, queue: dispatch_get_main_queue(), usingBlock: usingBlock)
	}
  
  func addPeriodicTimeObserverToPlayer(#name : String ,interval : CMTime
    , usingBlock : ((CMTime) -> Void) ) -> Void {
    playerObserverDictionary[name] = player.addPeriodicTimeObserverForInterval(interval, queue: dispatch_get_main_queue(), usingBlock: usingBlock)
  }
}
