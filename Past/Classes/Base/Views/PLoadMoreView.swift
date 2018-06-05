//
//  PLoadMoreView.swift
//  Past
//
//  Created by jiangliang on 2018/4/4.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PLoadMoreView: PTableViewCell {
    
    var stateLabel: UILabel?
    
    override init(style: PTableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        stateLabel = UILabel(frame: self.bounds)
        stateLabel?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stateLabel?.font = PFont(size: 12)
        stateLabel?.textAlignment = .center
        stateLabel?.textColor = UIColor.textColor
        self.contentView.addSubview(stateLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
