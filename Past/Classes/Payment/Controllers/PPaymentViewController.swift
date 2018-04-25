//
//  PPurchaseViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/24.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit
import StoreKit

class PPaymentViewController: PBaseViewController, PProductsViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    /// 服务器返回的 / 与Apple Pay 比对后有效的产品
    var products = [PProduct]()
    
    /// apple 返回产品
    var skProducts = [SKProduct]()
    
    /// 当前购买的产品
    var paymentProduct: PProduct?
    
    var bottomView: UIView?
    
    
    var productsView: PProductsView?
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWith(hex: "000000", alpha: 0.6)
        self.layoutSubviews()
        self.loadProducts()
        SKPaymentQueue.default().add(self)
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
       super.viewSafeAreaInsetsDidChange()
        if products.count > 0 {
            self.bottomView?.height += self.view.safeAreaInsets.bottom
            self.bottomView?.top = self.view.height - self.bottomView!.height
        }
    }
    
    func layoutSubviews() {
        bottomView = UIView(frame: CGRect(x: 6, y: 0, width: self.view.width - 12, height: 0))
        bottomView?.layer.cornerRadius = 5
        bottomView?.layer.masksToBounds = true
        bottomView?.backgroundColor = UIColor.white
        self.view.addSubview(bottomView!)
        
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: bottomView!.width, height: 40))
        bottomView?.addSubview(topView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: topView.width, height: topView.height))
        titleLabel.font = PFont(size: 16)
        titleLabel.textColor = UIColor.titleColor
        titleLabel.textAlignment = .center
        titleLabel.text = "充值"
        topView.addSubview(titleLabel)
        
        let cancelBtn = UIButton(frame: CGRect(x: 10, y: 0, width: 50, height: topView.height))
        cancelBtn.titleLabel?.font = PFont(size: 14)
        cancelBtn.setTitleColor(UIColor.greenColor, for: .normal)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.contentHorizontalAlignment = .left
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        topView.addSubview(cancelBtn)
        
        let alertBtn = UIButton(frame: CGRect(x: topView.width - 10 - 60, y: 0, width: 60, height: topView.height))
        alertBtn.titleLabel?.font = PFont(size: 14)
        alertBtn.setTitleColor(UIColor.placeholderColor, for: .normal)
        alertBtn.setTitle("充值须知", for: .normal)
        alertBtn.contentHorizontalAlignment = .right
        alertBtn.addTarget(self, action: #selector(purchaseNotice), for: .touchUpInside)
        topView.addSubview(alertBtn)
        
        productsView = PProductsView(frame: CGRect(x: 0, y: topView.bottom, width: bottomView!.width, height: 0))
        productsView?.delegate = self
        bottomView?.addSubview(productsView!)
    }
    
    func loadProducts() {
        let dataModel = PDataModel<PProduct, [PProduct]>()
        dataModel.url = "/product/products"
        dataModel.load(start: {
            
            Hud.showHudView(inView: self.view, lock: true)

        }) { (products, error) in
            
            if error == nil {
                self.products = products!
                var set = Set<String>()
                products?.forEach({ (p) in
                    set.insert(p.identifier!)
                })
                let request = SKProductsRequest(productIdentifiers: set)
                request.delegate = self
                request.start()
                
            } else {
               Hud.show(content: (error?.description)!)
            }
        }
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func purchaseNotice() {
        
    }
    
    func product(buyIndex: Int) {
        let product = skProducts[buyIndex]
        
        paymentProduct = products[buyIndex]
        
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            
            Hud.showHudView(inView: self.view, lock: true)
        } else {
            Hud.show(content: "您的手机没有打开程序内付费购买", withTime: 3)
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        Hud.hide()

        skProducts = response.products
        let invalidIdentifers = response.invalidProductIdentifiers
     
        var tmpProducts = [PProduct]()
        for p in products {
            let contain = invalidIdentifers.contains { (id) -> Bool in
                return p.identifier == id
            }
            if !contain {
                tmpProducts.append(p)
            }
        }
        
        products = tmpProducts
        
        self.productsView?.products = products
        self.bottomView?.height = self.productsView!.bottom
        if #available(iOS 11.0, *) {
            self.bottomView?.top = self.view.height - self.view.safeAreaInsets.bottom - self.bottomView!.height
            self.bottomView?.height += self.view.safeAreaInsets.bottom
        } else {
            self.bottomView?.top = self.view.height - self.bottomView!.height
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for t in transactions {
         
            if t.transactionState == .failed {
                Hud.show(content: "购买失败")
                queue.finishTransaction(t)
            } else if (t.transactionState == .purchased) {
                
                PHttpManager.requestAsynchronous(url: "/payment/buy", method: .post, parameters: ["productId": paymentProduct!.id!]) { (result) in
                    if result.code == 200 {
                        Hud.hide()
                        let data = result.data as! Dictionary<String, Int>
                        var session = PUserSession.instance.session
                        session?.balance = data["balance"]!
                        PUserSession.instance.cacheSession(session: session!)
                        
                        NotificationCenter.default.post(name: PUserSessionChanged, object: nil)
                        
                        self.cancel()
                    } else {
                        Hud.show(content: result.error!.description)
                    }
                }
                
                queue.finishTransaction(t)
            } else {
                print("\(t.transactionState)")
            }
        }
    }
    
}
