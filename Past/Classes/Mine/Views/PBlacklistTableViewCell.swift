//
//  PBlacklistTableViewCell.swift
//  Past
//
//  Created by jiangliang on 2018/5/8.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

protocol PBlacklistTableViewCellDelegate : NSObjectProtocol {
    func cancelBlacklist(cell: PBlacklistTableViewCell)
}

class PBlacklistTableViewCell: PTableViewCell {
    
    weak var delegate: PBlacklistTableViewCellDelegate?
    
    private var cancelBtn: UIButton?
    
    var user: PUser? {
        didSet {
            self.leftLabel?.text = user?.nickname
        }
    }
    
    override init(style: PTableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .description, reuseIdentifier: reuseIdentifier)
        cancelBtn = UIButton(frame: CGRect(x: Util.screenWidth() - 16 - 66, y: (self.height - 30)/2, width: 66, height: 30))
        cancelBtn?.layer.borderColor = UIColor.redColor.cgColor
        cancelBtn?.layer.borderWidth = 0.5
        cancelBtn?.layer.cornerRadius = 6
        cancelBtn?.layer.masksToBounds = true
        cancelBtn?.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        cancelBtn?.titleLabel?.font = PFont(size: 14)
        cancelBtn?.setTitle("取消拉黑", for: .normal)
        cancelBtn?.setTitleColor(UIColor.redColor, for: .normal)
        cancelBtn?.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        self.contentView.addSubview(cancelBtn!)
    }
    
    @objc func cancel() {
        delegate?.cancelBlacklist(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
