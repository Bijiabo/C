//
//  dialogueItemTableViewCell_right.swift
//  C
//
//  Created by bijiabo on 15/2/25.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import UIKit
import pop

class dialogueItemTableViewCell_right: UITableViewCell {
  
  @IBOutlet var textView: UITextView!
  var highlightImageView : UIImageView!
  
  var contentText : String = "" {
    didSet{
      textView.text = contentText
    }
  }
  
  override func prepareForReuse() {
    //清除旧的highli view
    for view in textView.subviews
    {
      if view.tag == 99
      {
        view.removeFromSuperview()
      }
    }
    
    //移动view
    
    //动画
    let ani : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
    ani.springBounciness = 5
    ani.springSpeed = 3
    ani.fromValue = self.contentView.frame.width
    ani.name = "showBubble"
    ani.delegate = self
    textView.pop_addAnimation(ani, forKey: "showBubble")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    textView.scrollEnabled = false
    textView.editable = false
    textView.backgroundColor = UIColor(red: 31/255, green: 149/255, blue: 254/255, alpha: 1)
    textView.textColor = UIColor.whiteColor()
    textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    //textView.backgroundColor = nil
    textView.layer.cornerRadius = 5.0
    textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 5.0)
    textView.textAlignment = NSTextAlignment.Left
    
    
    let tapRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "textViewTap:")
    textView.addGestureRecognizer(tapRecognizer)
    
    
  }
  
  func textViewTap(sender : AnyObject) -> Void{
    
    let pointLocation = sender.locationInView(textView)
    let tapCharacterRange = textView.characterRangeAtPoint(pointLocation)
    
    if tapCharacterRange?.start != nil && tapCharacterRange?.end != nil
    {
      let start = textView.positionFromPosition(tapCharacterRange!.start, offset: 0)
      let end = textView.positionFromPosition(tapCharacterRange!.end, offset: 5)
      
      let range : UITextRange = textView.textRangeFromPosition(tapCharacterRange?.start, toPosition: tapCharacterRange?.end)
      let rect1 = textView.firstRectForRange(range)
      showHighlightImageView(rect : rect1)
    }
  }
  
  func showHighlightImageView(#rect : CGRect) -> Void{
    highlightImageView = UIImageView(frame:rect)
    highlightImageView.tag = 99
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
