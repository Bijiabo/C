//
//  ViewController.swift
//  C
//
//  Created by bijiabo on 15/2/21.
//  Copyright (c) 2015 bijiabo. All rights reserved.
//


import UIKit
import WebKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController{
  
  var webView : WKWebView!
  
  override func loadView() {
    super.loadView()
    
    var contentController = WKUserContentController();
    var userScript = WKUserScript(
      source: "redHeader()",
      injectionTime: WKUserScriptInjectionTime.AtDocumentEnd,
      forMainFrameOnly: true
    )
    contentController.addUserScript(userScript)
    /*
    contentController.addScriptMessageHandler(
      self,
      name: "callbackHandler"
    )
    */
    var config = WKWebViewConfiguration()
    config.userContentController = contentController
    
    self.webView = WKWebView(
      frame: self.view.bounds,
      configuration: config
    )
    self.view = self.webView!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

	  self.title = "Atari"
    
    var url : NSURL! = NSURL(string:"http://127.0.0.1:8080/reading.html")
    var req = NSURLRequest(URL:url)
    webView.loadRequest(req)
    
    //Alamofire test
    Alamofire.request(.GET, "http://localhost:3001/app/C/classList.json").responseJSON {
      
      (_, _, jsonData, _) in
      let classData : JSON = JSON(jsonData!)
      println(classData[0])
      
    }
  }
  
  func userContentController(userContentController: WKUserContentController!, didReceiveScriptMessage message: WKScriptMessage!) {
    if(message.name == "callbackHandler") {
      println("JavaScript is sending a message \(message.body)")
    }
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  
  
}
