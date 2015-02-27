//
//  dialogueItemTableViewCell.swift
//  C
//
//  Created by bijiabo on 15/2/25.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import UIKit
import pop

class dialogueItemTableViewCell: UITableViewCell {
  
  @IBOutlet var textView: UITextView!
  var highlightImageView : UIImageView!

  override func prepareForReuse() {
    //清除旧的highli view
    for view in textView.subviews
    {
      if view.tag == 99
      {
        view.removeFromSuperview()
      }
    }
    
    animationForTextView(textView: textView)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    textView.scrollEnabled = false
    textView.editable = false
    textView.selectable = true
    
    
    textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    textView.layer.cornerRadius = 5.0
    textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 5.0)
    textView.textAlignment = NSTextAlignment.Left
    
    if self.reuseIdentifier == "dialogueItem_left"
    {
      textView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
      textView.textColor = UIColor.blackColor()
    }
    else
    {
      textView.backgroundColor = UIColor(red: 31/255, green: 149/255, blue: 254/255, alpha: 1)
      textView.textColor = UIColor.whiteColor()
    }
    
    let tapRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "textViewTap:")
    textView.addGestureRecognizer(tapRecognizer)
    
    animationForTextView(textView: textView)
  }
  
  func animationForTextView(#textView : UITextView) -> Void {
    //气泡动画
    let ani : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
    ani.springBounciness = 5
    ani.springSpeed = 3
    ani.fromValue = self.contentView.frame.width * (self.reuseIdentifier == "dialogueItem_left" ?  -1 :  1)
    ani.name = "showBubble"
    ani.delegate = self
    textView.pop_addAnimation(ani, forKey: "showBubble")
  }
  
  func textViewTap(sender : AnyObject) -> Void{
    
    let pointLocation = sender.locationInView(textView)
    let tapCharacterRange = textView.characterRangeAtPoint(pointLocation)
    
    if tapCharacterRange?.start != nil && tapCharacterRange?.end != nil
    {
      let start = textView.positionFromPosition(tapCharacterRange!.start, offset: 0)
      let end = textView.positionFromPosition(tapCharacterRange!.end, offset: 5)
      
      let textRange : NSRange = NSMakeRange(textView.offsetFromPosition(textView.beginningOfDocument , toPosition: start!), 1)
      let attributes : NSDictionary = textView.attributedText.attributesAtIndex(textRange.location, effectiveRange: nil)
      if attributes["type"] as String == "Word"
      {
        let wordRange : NSRange = attributes["range"] as NSRange
        let wordStart = textView.positionFromPosition(textView.beginningOfDocument, offset: wordRange.location)
        let wordEnd = textView.positionFromPosition(wordStart!, offset: wordRange.length)
        
        let range : UITextRange = textView.textRangeFromPosition(wordStart, toPosition: wordEnd)
        let rect1 = textView.firstRectForRange(range)
        showHighlightImageView(rect : rect1)
      }
      
    }
  }
  
  func showHighlightImageView(#rect : CGRect) -> Void{
    highlightImageView = UIImageView(frame:rect)
    highlightImageView.tag = 99
    textView.addSubview(highlightImageView)
    textView.sendSubviewToBack(highlightImageView)
    highlightImageView.backgroundColor = self.reuseIdentifier == "dialogueItem_left" ? UIColor.yellowColor() : UIColor(red:0.67, green:0.86, blue:0.75, alpha:1)
    //UIColor(red: 176/255, green: 239/255, blue: 136/255, alpha: 0.5)
    
    let ani : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
    ani.springBounciness = 5
    ani.springSpeed = 1
    ani.fromValue = NSValue(CGSize: CGSizeMake(0.01, 1.0))
    ani.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
    ani.name = "hightlightSize"
    ani.delegate = self
    highlightImageView.pop_addAnimation(ani, forKey: "hightlightSize")
  }
  
  func sizeForMessage(#textview : UITextView, message : NSString) -> CGSize {
    let messageFont : UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    
    let messageConstraints : CGSize = CGSizeMake(textview.frame.size.width, CGFloat.max);
    
    var messageSize : CGSize = message.boundingRectWithSize(messageConstraints,
      options : NSStringDrawingOptions.UsesLineFragmentOrigin,
      attributes : [NSFontAttributeName : messageFont],
      context:nil).size
    
    
    
    return messageSize
  }
  
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
