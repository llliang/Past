//
//  PDescriptionTableViewCell.swift
//  Past
//
//  Created by jiangliang on 2018/4/6.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PTableViewCell : UITableViewCell {

    struct PTableViewCellStyle: OptionSet {
        let rawValue: UInt
        
        static let `default` = PTableViewCellStyle(rawValue: 1 << 0)
        static let icon = PTableViewCellStyle(rawValue: 1 << 1)
        static let description = PTableViewCellStyle(rawValue: 1 << 2)
        static let content = PTableViewCellStyle(rawValue: 1 << 3)
        static let arrow = PTableViewCellStyle(rawValue: 1 << 4)
    }
    
    var iconImageView: UIImageView?
    var leftLabel: UILabel?
    var rightLabel: UILabel?
    var arrowView: PArrowView?
    
    init(style: PTableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        if style.contains(.default) {
            return
        }
        
        var left: CGFloat = 16.0
        
        if style.contains(.icon) {
            iconImageView = UIImageView(frame: CGRect(x: left, y: (self.height - 20.0)/2.0, width: 20.0, height: 20.0))
            iconImageView?.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
            iconImageView?.layer.masksToBounds = true
            iconImageView?.contentMode = .scaleAspectFill
            self.contentView.addSubview(iconImageView!)
            left += 20 + 10
        }
        
        if style.contains(.description) {
            
            leftLabel = UILabel(frame: CGRect(x: left, y: 0, width: 0, height: self.height))
            leftLabel?.font = PFont(size: 16)
            leftLabel?.autoresizingMask = .flexibleHeight
            leftLabel?.textColor = UIColor.darkGray
            self.contentView.addSubview(leftLabel!)
            
            leftLabel?.addObserver(self, forKeyPath: "text", options: .new, context: nil)
            
            left += leftLabel!.right + 20
        }
        
        if style.contains(.arrow) {
            arrowView = PArrowView(frame: CGRect(x: UIScreen.main.bounds.width - 16 - 8, y: (self.height - 12)/2.0, width: 8, height: 12))
            arrowView?.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
            self.contentView.addSubview(arrowView!)
        }
        
        if style.contains(.content) {
            
            rightLabel = UILabel(frame: CGRect(x: left, y: 0, width: 0, height: self.height))
            rightLabel?.font = PFont(size: 16)
            rightLabel?.autoresizingMask = .flexibleHeight
            rightLabel?.textColor = UIColor.gray
            rightLabel?.textAlignment = .right

            if let v = arrowView {
                rightLabel?.width = v.left - leftLabel!.right - 20
            } else {
                rightLabel?.width = UIScreen.main.bounds.width - 16 - leftLabel!.right - 20
            }
            self.contentView.addSubview(rightLabel!)
        }   
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as! UILabel) == leftLabel {
//            let text = leftLabel!.text! as NSString
            let width = NSString(string: leftLabel!.text!).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: leftLabel!.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: leftLabel!.font], context: nil).width
            leftLabel?.width = width
            
            rightLabel?.left = leftLabel!.right + 10
  
            if let v = arrowView {
                rightLabel?.width = v.left - leftLabel!.right - 20
            } else {
                rightLabel?.width = UIScreen.main.bounds.width - 16 - leftLabel!.right - 20
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class PArrowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint.zero)
        bezierPath.addLine(to: CGPoint(x: self.width, y: self.height/2.0))
        bezierPath.addLine(to: CGPoint(x: 0.0, y: self.height))
        
        let shaperLayer = CAShapeLayer()
        shaperLayer.fillColor = UIColor.clear.cgColor
        shaperLayer.lineWidth = 1
        shaperLayer.strokeColor = UIColor(white: 0.7, alpha: 0.75).cgColor
        shaperLayer.path = bezierPath.cgPath
        self.layer.addSublayer(shaperLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
