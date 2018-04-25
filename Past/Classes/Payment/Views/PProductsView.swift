//
//  PProductsView.swift
//  Past
//
//  Created by jiangliang on 2018/4/24.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PProductItemView: UIButton {
    
    // 充值多少
    var contentButton: UIButton?
    var priceLabel: UILabel?
    
    var product: PProduct? {
        didSet {
            contentButton?.setImage(UIImage(named: "payment_icon"), for: .normal)
            contentButton?.setTitle(" \(product!.value)", for: .normal)
            
            priceLabel?.text = "¥ \(product!.price)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentButton = UIButton(frame: CGRect(x: 0, y: (frame.height - 40)/2, width: frame.width, height: 20))
        contentButton?.isUserInteractionEnabled = false
        contentButton?.titleLabel?.font = PFont(size: 16)
        contentButton?.setImage(nil, for: .normal)
        contentButton?.setTitleColor(UIColor.greenColor, for: .normal)
        self.addSubview(contentButton!)
        
        priceLabel = UILabel(frame: CGRect(x: 0, y: contentButton!.bottom, width: self.width, height: 20))
        priceLabel?.font = PFont(size: 16)
        priceLabel?.textAlignment = .center
        priceLabel?.textColor = UIColor.textColor
        self.addSubview(priceLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol PProductsViewDelegate: NSObjectProtocol {
    func product(buyIndex: Int)
}

class PProductsView: UIView {

    weak var delegate: PProductsViewDelegate?
    
    var products: [PProduct]? {
        didSet {

            self.subviews.forEach { (v) in
                v.removeFromSuperview()
            }
            if let tmps = products {
                let width = self.width/3
                
                var selfHeight: CGFloat = 0
                for (index, product) in tmps.enumerated() {
                    let item = PProductItemView(frame: CGRect(x: width * CGFloat(index%3), y: CGFloat(index/3) * width, width: width, height: width))
                    item.product = product
                    item.addTarget(self, action: #selector(itemClicked), for: .touchUpInside)
                    item.tag = 1000 + index
                    self.addSubview(item)
                    selfHeight = item.bottom
                    
                    if index%3 == 0 {
                        let hLine = UIView(frame: CGRect(x: 0, y: item.top - 0.5, width: self.width, height: 0.5))
                        hLine.backgroundColor = UIColor.seperatorColor
                        self.addSubview(hLine)
                    }
                }
                self.height = selfHeight
                
                for i in 1...2 {
                    let vLine = UIView(frame: CGRect(x: width * CGFloat(i), y: 0, width: 0.5, height: selfHeight))
                    vLine.backgroundColor = UIColor.seperatorColor
                    self.addSubview(vLine)
                }
                
                let bottomLine = UIView(frame: CGRect(x: 0, y: selfHeight - 0.5, width: self.width, height: 0.5))
                bottomLine.backgroundColor = UIColor.seperatorColor
                self.addSubview(bottomLine)
            }
            
        }
    }
    
    @objc func itemClicked(item: PProductItemView) {
        if let _ = delegate {
            delegate?.product(buyIndex: item.tag - 1000)
        }
    }

}
