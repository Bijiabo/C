//
//  AppDelegate.swift
//  C
//
//  Created by bijiabo on 15/2/21.
//  Copyright (c) 2015 bijiabo. All rights reserved.
//


import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  
  var window: UIWindow?
  
  
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let webServers = webServer(port: 8080)
    
    return true
  }
  
  
  func applicationWillResignActive(application: UIApplication) {
  }
  
  
  func applicationDidEnterBackground(application: UIApplication) {
  }
  
  
  func applicationWillEnterForeground(application: UIApplication) {
  }
  
  
  func applicationDidBecomeActive(application: UIApplication) {
  }
  
  
  func applicationWillTerminate(application: UIApplication) {
  }
  
  
  
  
}
