//
//  shop.swift
//  C
//
//  Created by bijiabo on 15/2/26.
//  Copyright (c) 2015年 bijiabo. All rights reserved.
//

import UIKit
import StoreKit

class shop: NSObject , SKProductsRequestDelegate , SKPaymentTransactionObserver{

  var products : Array<AnyObject>!
  var viewController : shopViewController!
  
  init(shopVC : shopViewController){
    super.init()
    
    self.viewController = shopVC
    products = []
    
    if SKPaymentQueue.canMakePayments()
    {
      getProductInfo()
      addTransactionObserver()
    }
    else
    {
      println("失败，用户禁止应用内付费购买.")
    }
    

  }
  
  func getProductInfo() -> Void {
    let set : NSSet = NSSet(array: ["monthMember1","diamond6"])
    let request : SKProductsRequest = SKProductsRequest(productIdentifiers: set)
    request.delegate = self
    request.start()
  }
  
  func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
    
    let product : NSArray = response.products
    if product.count == 0
    {
      println("无法获取产品信息，购买失败。")
      return
    }
    
    //刷新产品信息列表
    self.products = []
    for productItem in product
    {
      let title : String = productItem.localizedTitle
      let price = productItem.price
      let priceLocale = productItem.priceLocale
      let priceString = priceAsString(price: price, priceLocale: priceLocale)
      
      self.products.append([
        "title" : title,
        "price" : price,
        "priceString" : priceString,
        "description" : productItem.localizedDescription
        ])
    }
    
    self.viewController.didGetProductsList()
    
    //请求支付
    /*
    let payment : SKPayment = SKPayment(product: product[0] as SKProduct)
    SKPaymentQueue.defaultQueue().addPayment(payment)
    */
  }
  
  func addTransactionObserver() -> Void {
    SKPaymentQueue.defaultQueue().addTransactionObserver(self)
  }
  
  func removeTransactionObserver() -> Void {
    SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
  }
  
  func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
    
    //用户购买有结果时
    for transaction:SKPaymentTransaction in transactions as [SKPaymentTransaction]
    {
      switch transaction.transactionState
      {
      case SKPaymentTransactionState.Purchased:
        NSLog("transactionIdentifier = %@", transaction.transactionIdentifier);
        self.completeTransaction(transaction)
        
      case SKPaymentTransactionState.Failed:
        NSLog("交易失败")
        self.failedTransaction(transaction)
        
      case SKPaymentTransactionState.Restored:
        NSLog("已经购买过该商品")
        self.restoreTransaction(transaction)
        
      case SKPaymentTransactionState.Purchasing:
        NSLog("商品添加进列表");
        
      default:
        NSLog("default...")
      }
    }
  }
  
  func completeTransaction(transaction:SKPaymentTransaction) -> Void {
    // Your application should implement these two methods.
    let productIdentifier : String = transaction.payment.productIdentifier
    let receipt : String = transaction.transactionIdentifier //[transaction.transactionReceipt base64EncodedString]
    if productIdentifier != ""
    {
      // 向自己的服务器验证购买凭证
    }
    
    // Remove the transaction from the payment queue.
    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
  }
  
  func failedTransaction(transaction:SKPaymentTransaction) -> Void {
    if transaction.error.code != SKErrorPaymentCancelled
    {
      println("购买失败")
    }
    else
    {
      println("用户取消交易")
    }
    
    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
  }
  
  func restoreTransaction(transaction:SKPaymentTransaction) -> Void {
    // 对于已购商品，处理恢复购买的逻辑
    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
  }
  
  
  func priceAsString(#price:NSDecimalNumber, priceLocale : NSLocale) -> String {
    let formatter : NSNumberFormatter = NSNumberFormatter()
    formatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4
    formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
    formatter.locale = priceLocale
    
    let str : String = formatter.stringFromNumber(price)!
    return str
  }
  
  
  /*
  - (NSString *) priceAsString
  {
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
  [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  [formatter setLocale:[self priceLocale]];
  
  NSString *str = [formatter stringFromNumber:[self price]];
  [formatter release];
  return str;
  }
  */
}
