//
// Created by bijiabo on 15/2/25.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

//
//  getData.swift
//  tableViewInUIView
//
//  Created by bijiabo on 15/1/2.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class jsonData{
	let jsonURL : NSURL!
	let jsonObject : JSON!
	let dataObject : NSObject!

	init(fileName filename : String , withExtension : String){
		let jsonPath : String! = NSBundle.mainBundle().pathForResource(filename, ofType: withExtension)
		if NSFileManager().fileExistsAtPath(jsonPath)
		{
			jsonURL = NSBundle.mainBundle().URLForResource(filename, withExtension: withExtension)!
			jsonObject = JSON(data: NSData(contentsOfURL: jsonURL)!, options: NSJSONReadingOptions.MutableContainers, error: nil)
		}
		else
		{
			jsonObject = JSON([])
		}
	}

	init(filePath : String){
		if NSFileManager().fileExistsAtPath(filePath)
		{
			let data : NSData! = NSData(contentsOfFile: filePath)
			jsonObject = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
		}
		else
		{
			jsonObject = JSON([])
		}
	}

	func getJSON() -> JSON {
		return jsonObject
	}

}