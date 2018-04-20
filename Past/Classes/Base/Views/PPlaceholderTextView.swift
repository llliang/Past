//
//  PPlaceholderTextView.swift
//  Past
//
//  Created by jiangliang on 2018/4/6.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PPlaceholderTextView: UITextView {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var placeholder: String? {
        didSet {
            placeholderTextView?.text = placeholder
        }
    }
    var placeholderColor: UIColor? {
        didSet {
            placeholderTextView?.textColor = placeholderColor
        }
    }
    
    override var contentInset: UIEdgeInsets {
        didSet {
            placeholderTextView?.contentInset = contentInset
        }
    }
    
    var placeholderTextView: UITextView?
    
    override var font: UIFont? {
        didSet {
            placeholderTextView?.font = font
        }
    }
    
    override var text: String! {
        didSet {
            placeholderTextView?.isHidden = (text != nil) && text.count > 0
        }
    }
  
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        placeholderTextView = UITextView(frame: self.bounds)
        placeholderTextView!.isUserInteractionEnabled = false
        placeholderTextView!.font = self.font
        placeholderTextView!.textColor = UIColor.placeholderColor
        placeholderTextView!.showsVerticalScrollIndicator = false
        placeholderTextView!.showsHorizontalScrollIndicator = false
        placeholderTextView!.isScrollEnabled = false
        placeholderTextView!.backgroundColor = UIColor.clear;
        self.addSubview(placeholderTextView!)
        
        if #available(iOS 11.0, *) {
            placeholderTextView?.contentInsetAdjustmentBehavior = .never
            self.contentInsetAdjustmentBehavior = .never
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeForPlaceholder), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    @objc func textDidChangeForPlaceholder(notification: Notification) {
        placeholderTextView?.isHidden = (self.text != nil) && self.text.count > 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
