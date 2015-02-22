//
//  webServer.swift
//  C
//
//  Created by bijiabo on 15/2/21.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import Foundation
import GCDWebServer

class webServer:NSObject {
  var webServer : GCDWebServer
  
  init(port:UInt) {
    webServer = GCDWebServer()
    
    /*
    //GET
    webServer.addDefaultHandlerForMethod("GET", requestClass: GCDWebServerRequest.self, processBlock: {request in
      return GCDWebServerDataResponse(HTML:"<html><body><p>Hello World</p></body></html>")
    })
    
    webServer.startWithPort(port, bonjourName: nil)
    
    println("Visit \(webServer.serverURL) in your web browser")
    */
    
    var webServerPath : String! = NSBundle.mainBundle().resourcePath
    webServerPath = NSString(string: webServerPath).stringByAppendingPathComponent("/webServer")
    
    webServer.addGETHandlerForBasePath("/", directoryPath: webServerPath, indexFilename: nil, cacheAge: 3600, allowRangeRequests: true)
    webServer.startWithPort(port, bonjourName: nil)
    
    super.init()
  }
  
}