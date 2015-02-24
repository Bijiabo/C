//
//  testViewController.swift
//  C
//
//  Created by bijiabo on 15/2/23.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import UIKit
import pop

class testViewController: UIViewController , UITextViewDelegate , UIGestureRecognizerDelegate{
  
  @IBOutlet var testImage: UIImageView!
  @IBOutlet var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    testImage.image = UIImage(named: "images/01.jpg")!
    let imagelayer = testImage.layer
    testImage.layer.backgroundColor = UIColor.grayColor().CGColor
    testImage.layer.borderColor = UIColor.redColor().CGColor
    testImage.layer.borderWidth = 3.0
    imagelayer.shadowColor = UIColor.greenColor().CGColor
    imagelayer.shadowOffset = CGSizeMake(15.0, 15.0)
    imagelayer.shadowOpacity = 0.8
    imagelayer.shadowRadius = 15.0
    imagelayer.opacity = 0.0
    
    var basicAni : POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
    basicAni.fromValue = 0.0
    basicAni.toValue = 1.0
    basicAni.duration = 5.0
    basicAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear )
    basicAni.name = "fadeAnimation"
    basicAni.delegate = self
    imagelayer.pop_addAnimation(basicAni, forKey: "fadeAnimation")
    
    /*
    //fade animation
    var fadeAnimation : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
    fadeAnimation.fromValue = 0.0
    fadeAnimation.toValue = 1.0
    fadeAnimation.duration = 5.0
    imagelayer.addAnimation(fadeAnimation, forKey: nil)
    */
    /*
    testImage.animationImages = [UIImage(named: "images/01.jpg")!,UIImage(named: "images/02.jpg")!]
    testImage.animationDuration = 2
    testImage.startAnimating()
    */
    
    //textView
    var content = NSAttributedString(string: "Heres to the crazy ones. The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently.They're not fond of rules and they have no respect for the status quo. You can quote them,disagree with them, glorify or vilify them. About the only thing you cant do is ignore them. Because they change things. They push the human race forward. And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do.")
    textView.editable = false
    //textView.selectable = false
    textView.delegate = self
    textView.attributedText = content
    
    let tapRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "textViewTap:")
    textView.addGestureRecognizer(tapRecognizer)
  }
  
  func textViewDidChangeSelection(textView: UITextView) {
    println("textView did change selection")
    println(textView.selectedRange)
    let textRange : UITextRange = textView.selectedTextRange!
    let rect = textView.firstRectForRange(textRange)
    
    //println(rect)
  }
  
  func textViewTap(sender : AnyObject) -> Void{
    
    let pointLocation = sender.locationInView(textView)
    let tapCharacterRange = textView.characterRangeAtPoint(pointLocation)
    
    let start = textView.positionFromPosition(tapCharacterRange!.start, offset: 0)
    let end = textView.positionFromPosition(tapCharacterRange!.end, offset: 5)
    
    let range : UITextRange = textView.textRangeFromPosition(tapCharacterRange?.start, toPosition: tapCharacterRange?.end)
    let rect1 = textView.firstRectForRange(range)
    println(rect1)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(animated: Bool) {
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  @IBAction func goback(sender: AnyObject) {
    //navigationController?.popToRootViewControllerAnimated(true)
    dismissViewControllerAnimated(true, completion: nil)
  }
}
