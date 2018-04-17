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
    var stamp = PStamp() {
        didSet {
            if let url = stamp.image {
                self.kf.setImage(with: URL(string: url), for: .normal, placeholder: nil, options: nil, progressBlock: nil) { (image, error, type, url) in
                    self.setImage(image, for: .highlighted)
                }
            }
        }
    }
}

protocol PStampsViewDelegate: NSObjectProtocol {
    func stampClicked(stamp: PStamp)
}

class PStampsView: UIScrollView {

    var stampDelegate: PStampsViewDelegate?
    
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
