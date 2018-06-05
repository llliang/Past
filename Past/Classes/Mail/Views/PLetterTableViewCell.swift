//
//  PLetterTableViewCell.swift
//  Past
//
//  Created by jiangliang on 2018/4/19.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PLetterTableViewCell: PTableViewCell {

    var statusLabel: UILabel?
    var timeLabel: UILabel?
    var dotView: UIView?

    var letter: PLetter? {
        
        didSet {
            dotView?.isHidden = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm"
            
            if letter?.sender.userId == PUserSession.instance.session?.user?.userId {
                statusLabel?.text = "寄"
                statusLabel?.layer.borderColor = UIColor.textColor.cgColor
                
                timeLabel?.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(letter!.receivingTime))) + "送达"
            } else {
                statusLabel?.text = "收"
                statusLabel?.layer.borderColor = UIColor.textColor.cgColor
                if letter?.status == 0 {
                    dotView?.isHidden = false
                }
                timeLabel?.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(letter!.time)))
            }
        }
    }
    
    override init(style: PTableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        statusLabel = UILabel(frame: CGRect(x: 16, y: (self.height - 30)/2, width: 30, height: 30))
        statusLabel?.font = PFont(size: 18)
        statusLabel?.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        statusLabel?.layer.masksToBounds = true
        statusLabel?.layer.cornerRadius = statusLabel!.height/2
        statusLabel?.textAlignment = .center
        statusLabel?.layer.borderWidth = 1
        self.contentView.addSubview(statusLabel!)
        
        dotView = UIView(frame: CGRect(x: statusLabel!.right - 5, y: statusLabel!.top - 2, width: 8, height: 8))
        dotView?.backgroundColor = UIColor.redColor
        dotView?.autoresizingMask = .flexibleTopMargin
        dotView?.layer.masksToBounds = true
        dotView?.layer.cornerRadius = 4
        self.contentView.addSubview(dotView!)
        
        timeLabel = UILabel(frame: CGRect(x: statusLabel!.right + 10, y: 0, width: UIScreen.main.bounds.width - 16 - 10 - statusLabel!.right, height: self.height))
        timeLabel?.textAlignment = .right
        timeLabel?.autoresizingMask = .flexibleHeight
        timeLabel?.font = PFont(size: 16)
        timeLabel?.textColor = UIColor.placeholderColor
        self.contentView.addSubview(timeLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
