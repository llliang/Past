//
//  PStampsView.swift
//  Past
//
//  Created by jiangliang on 2018/4/10.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit
import Kingfisher

class PStampView: UIButton {
    
    private var percentLabel: UILabel?
    private var periodLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        percentLabel = UILabel(frame: CGRect(x: 15, y: 10, width: frame.width - 30, height: 16))
        percentLabel?.font = PFont(size: 12)
        percentLabel?.textColor = UIColor.white
        self.addSubview(percentLabel!)
        
        periodLabel = UILabel(frame: CGRect(x: 15, y: frame.height - 26, width: frame.width - 30, height: 16))
        periodLabel?.font = PFont(size: 12)
        periodLabel?.textColor = UIColor.white
        periodLabel?.textAlignment = .right
        self.addSubview(periodLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var stamp = PStamp() {
        didSet {
            if let url = stamp.image {
                self.kf.setImage(with: URL(string: url), for: .normal, placeholder: nil, options: nil, progressBlock: nil) { (image, error, type, url) in
                    self.setImage(image, for: .highlighted)
                }
                percentLabel?.text = "\(stamp.price ?? 0)₩"
                let day = stamp.period!/(24*60*60)
                let hour = (stamp.period! - day*24*60*60)/(60*60)
                if day > 0 {
                    periodLabel?.text = "\(day)天"
                } else {
                    periodLabel?.text = "\(hour)小时"
                }
            }
        }
    }
}

protocol PStampsViewDelegate: NSObjectProtocol {
    func stampClicked(stamp: PStamp)
}

class PStampsView: UIScrollView {

    weak var stampDelegate: PStampsViewDelegate?
        
    var stamps: [PStamp]? {
        didSet {
            self.subviews.forEach { (v) in
                v.removeFromSuperview()
            }
            if let tmps = stamps {
                for (index, stamp) in tmps.enumerated() {
                    let view = PStampView(frame: CGRect(x: 5 + (100 + 5)*index, y:0, width: 100, height: 120))
                    view.stamp = stamp
                    view.addTarget(self, action: #selector(itemClicked), for: .touchUpInside)
                    self.addSubview(view)
                }
            }
        }
    }
    
    @objc func itemClicked(btn: PStampView) {
        if stampDelegate != nil {
            stampDelegate?.stampClicked(stamp: btn.stamp)
        }
    }
}
