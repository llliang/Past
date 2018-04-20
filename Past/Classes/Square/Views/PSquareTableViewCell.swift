//
//  PMainTableViewCell.swift
//  Past
//
//  Created by jiangliang on 2018/4/8.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PSquareTableViewCell: PTableViewCell {
    var genderLabel: UILabel?
    var nameLabel: UILabel?
    var introduceLabel: UILabel?
    
    var user: PUser? {
        didSet {
            switch user?.gender {
            case 0:
                genderLabel?.text = "女"
            case 1:
                genderLabel?.text = "男"
            default:
                genderLabel?.text = "密"
            }
            nameLabel?.text = user?.nickname
            
            if let intro = user?.description {
                if intro.count > 0 {
                    introduceLabel?.text = user?.description
                    return
                }
            }
            introduceLabel?.text = "这家伙很懒，没有介绍自己"
        }
    }
    
    override init(style: PTableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        genderLabel = UILabel(frame: CGRect(x: 16, y: 8, width: 20, height: 20))
        genderLabel?.layer.cornerRadius = 10
        genderLabel?.layer.masksToBounds = true
        genderLabel?.layer.borderColor = UIColor.greenColor.cgColor
        genderLabel?.layer.borderWidth = 1
        genderLabel?.font = PFont(size: 14)
        genderLabel?.textAlignment = .center
        self.contentView.addSubview(genderLabel!)
        
        nameLabel = UILabel(frame: CGRect(x: genderLabel!.right + 10, y: 6, width: self.width - genderLabel!.right - 10 - 16, height: 24))
        nameLabel?.font = PFont(size: 16)
        nameLabel?.autoresizingMask = .flexibleWidth
        nameLabel?.textColor = UIColor.titleColor
        self.contentView.addSubview(nameLabel!)
        
        introduceLabel = UILabel(frame: CGRect(x: 16, y: nameLabel!.bottom , width: self.width - 32, height: 50))
        introduceLabel?.numberOfLines = 2
        introduceLabel?.autoresizingMask = .flexibleWidth
        introduceLabel?.textColor = UIColor.textColor
        introduceLabel?.font = PFont(size: 14)
        self.contentView.addSubview(introduceLabel!)
    }

    override class func cellHeight(with: Any?) -> CGFloat {
        return 80
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
