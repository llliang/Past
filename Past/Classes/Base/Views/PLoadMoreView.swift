//
//  PLoadMoreView.swift
//  Past
//
//  Created by jiangliang on 2018/4/4.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PLoadMoreView: UIView {
    
    var stateLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stateLabel = UILabel(frame: self.bounds)
        stateLabel?.font = PFont(size: 12)
        stateLabel?.textAlignment = .center
        stateLabel?.textColor = UIColor.textColor
        self.addSubview(stateLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
