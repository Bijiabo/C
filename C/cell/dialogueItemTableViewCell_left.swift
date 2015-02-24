//
//  dialogueItemTableViewCell.swift
//  C
//
//  Created by bijiabo on 15/2/25.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import UIKit
import pop

class dialogueItemTableViewCell_left: UITableViewCell {
  
  @IBOutlet var textView: UITextView!
  var highlightImageView : UIImageView!
  
  var contentText : String = "" {
    didSet{
      textView.text = contentText
      
      var frame:CGRect = textView.frame
      frame.size.height = textView.contentSize.height
      //textView.frame = frame
      
      println("----")
      println(textView.frame)
      //bubbleBackground(textView)
      
    }
  }
  
  override func prepareForReuse() {
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    textView.scrollEnabled = false
    textView.editable = false
    textView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
//    textView.backgroundColor = nil
    textView.layer.cornerRadius = 5.0
    
    
    let tapRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "textViewTap:")
    textView.addGestureRecognizer(tapRecognizer)
  }
  
  func textViewTap(sender : AnyObject) -> Void{
    
    let pointLocation = sender.locationInView(textView)
    let tapCharacterRange = textView.characterRangeAtPoint(pointLocation)
    
    let start = textView.positionFromPosition(tapCharacterRange!.start, offset: 0)
    let end = textView.positionFromPosition(tapCharacterRange!.end, offset: 5)
    
    let range : UITextRange = textView.textRangeFromPosition(tapCharacterRange?.start, toPosition: tapCharacterRange?.end)
    let rect1 = textView.firstRectForRange(range)
    println(rect1)
    showHighlightImageView(rect : rect1)
  }
  
  func showHighlightImageView(#rect : CGRect) -> Void{
    highlightImageView = UIImageView(frame:rect)
    textView.addSubview(highlightImageView)
    textView.sendSubviewToBack(highlightImageView)
    highlightImageView.backgroundColor = UIColor.yellowColor()
    //UIColor(red: 176/255, green: 239/255, blue: 136/255, alpha: 0.5)
    
    let ani : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
    ani.springBounciness = 14
    ani.springSpeed = 1
    ani.fromValue = NSValue(CGSize: CGSizeMake(0.01, 1.0))
    ani.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
    ani.name = "hightlightSize"
    ani.delegate = self
    highlightImageView.pop_addAnimation(ani, forKey: "hightlightSize")
  }

  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
