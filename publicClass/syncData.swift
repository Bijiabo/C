//
//  syncData.swift
//  WKWebkitLearning
//
//  Created by bijiabo on 15/1/27.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation
import SQLite
import SwiftyJSON

class syncData:NSObject{
  dynamic var classIndex : String = ""
  dynamic var classMode : String = "slow"
  dynamic var classTitle : String = ""
  dynamic var playerObserver : AnyObject!
  
  dynamic var mainScreenDidLoad : Bool = false
  dynamic var initData : String = ""
  dynamic var currentData : String = ""
  
  let documentPath : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String
  let cachePath : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory , .UserDomainMask , true).first as String
  
  //sqlite3
  let db = Database("\(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String)/db.sqlite3")
  
  //columns
  let id = Expression<Int>("id")
  let classId = Expression<Int>("classId")
  let title = Expression<String>("title")
  let progress = Expression<Double>("progress")
  
  func prepareSQLite3() -> Void{
    
    //新建课程列表 表
    let classTable = db["classes"]
    
    db.create(table: classTable, ifNotExists: true) { t in     // CREATE TABLE "class" (
      t.column(self.id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
      t.column(self.classId)
      t.column(self.title)
      t.column(self.progress, defaultValue: 0.0)
    }
    
    println("SQLite3 init")
  }
  
  func insertClassList(#id:Int,title:String) -> Int {
    
    //添加课程列表数据
    
    let classTable = db["classes"]
    if let insertId = classTable.insert(self.classId <- id, self.title <- title)
    {
      
      println("class list count in SQLite3 : \(classTable.count)")
      
      return insertId
    }
    else
    {
      return 0
    }
  }
  
  func updateClassProgress(#id : Int ,progress : Double, max : Double = 1.0) -> Bool{
    
    //更新课程学习进度
    
    let classTable = db["classes"]
    var classQueryData : Query?
    
    classQueryData = classTable.filter(self.classId == id)
    
    let progressNow : Double = classQueryData?.first?.get(self.progress) as Double!
    if progressNow + progress <= max
    {
      if classQueryData?.update(self.progress += progress) > 0
      {
        return true
      }
      else
      {
        return false
      }
    }
    else
    {
      return true
    }
    
  }
  
  func getClassListData() -> JSON {
    var classListData : Array<AnyObject> = Array<AnyObject>()
    for classItem in db["classes"]
    {
      let dataItem = ["id" : classItem[self.classId],
        "title" : classItem[self.title],
        "progress" : classItem[self.progress]
      ]
      classListData.append(dataItem)
    }
    
    return JSON(classListData)
  }
  
  
  func dataPath(appendingPath : String) -> String{
    let dataPath : String = NSString(string: self.cachePath).stringByAppendingPathComponent("classDatas/\(appendingPath)") as String
    return dataPath
  }
}