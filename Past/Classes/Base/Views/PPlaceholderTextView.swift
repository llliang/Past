//
//  PPlaceholderTextView.swift
//  Past
//
//  Created by jiangliang on 2018/4/6.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PPlaceholderTextView: UITextView {
    
    var lineSpacing: CGFloat = 0 {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.firstLineHeadIndent = self.font!.pointSize*2
            self.typingAttributes = [NSAttributedString.Key.font: self.font!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        }
    }

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
    
    override var attributedText: NSAttributedString! {
        didSet {
            placeholderTextView?.isHidden = (attributedText != nil) && attributedText.length > 0
        }
    }
    
//    override func draw(_ rect: CGRect) {
//        let context = UIGraphicsGetCurrentContext()
//        context?.setStrokeColor(UIColor.greenColor.cgColor)
//        context?.setLineWidth(0.5)
//        context?.beginPath()
//
//        let numberOfLines = self.contentSize.height/(self.font!.lineHeight + self.font!.leading + 10)
//        let baselineOffset: CGFloat = 5
//
//        for i in 1...Int(numberOfLines) {
//            context?.move(to: CGPoint(x: 0, y: self.contentInset.top + (self.font!.lineHeight + self.font!.leading + 10)*CGFloat(i) + baselineOffset))
//            context?.addLine(to: CGPoint(x: self.width, y:  self.contentInset.top + (self.font!.lineHeight + self.font!.leading + 10)*CGFloat(i) + baselineOffset))
//        }
//        context?.draw(<#T##layer: CGLayer##CGLayer#>, at: <#T##CGPoint#>)
//        context?.closePath()
//        context?.strokePath()
//
//
//    }
  
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeForPlaceholder), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc func textDidChangeForPlaceholder(notification: Notification) {
        placeholderTextView?.isHidden = (self.text != nil) && self.text.count > 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
