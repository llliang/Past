//
//  PReadLetterViewController.swift
//  Past
//
//  Created by jiangliang on 2018/5/3.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PReadLetterViewController: PBaseViewController {

    var sender: PUser?
    var addressee: PUser?
    
    var letter: PLetter?
    
    var container: UIScrollView?
    
    var senderLabel: UILabel?
    var contentLabel: UILabel?
    var signLabel: UILabel?
    
    // 若在查看信件状态下 判断是否是收信人
    var isSender: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isSender = (sender?.userId == PUserSession.instance.session?.user?.userId)
        
        var rightTitle: String
        if isSender {
            rightTitle = "再写一封"
        } else {
            rightTitle = "回复"
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightTitle, style: .right, target: self, action: #selector(writeLetter))
        self.layoutSubviews()
    }
    
    func layoutSubviews() {
        container = UIScrollView(frame: self.view.bounds)
        container?.autoresizingMask = .flexibleHeight
        self.view.addSubview(container!)
        
        senderLabel = UILabel(frame: CGRect(x: 13, y: 10, width: container!.width - 26, height: 20))
        senderLabel?.font = PFont(size: 16)
        senderLabel?.text = "\(addressee?.nickname ?? ""):"
        container?.addSubview(senderLabel!)
        
        contentLabel = UILabel(frame: CGRect(x: 13, y: (senderLabel?.bottom)! + 4, width: container!.width - 26, height: 0))
        contentLabel?.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.firstLineHeadIndent = contentLabel!.font.pointSize*2
        container?.addSubview(contentLabel!)
        
        contentLabel?.attributedText = NSAttributedString(string: letter!.content, attributes: [NSAttributedString.Key.font: PFont(size: 16)!, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        contentLabel?.height = contentLabel!.attributedText!.boundingRect(with: CGSize(width: contentLabel!.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).height
        
        
        signLabel = UILabel(frame: CGRect(x: 13, y: contentLabel!.bottom, width: self.view.width - 26, height: 60))
        signLabel?.numberOfLines = 0
        signLabel?.font = PFont(size: 16)
        signLabel?.textAlignment = .right
        container?.addSubview(signLabel!)
        self.sign()
        
        container?.contentSize = CGSize(width: container!.width, height: max(container!.height, signLabel!.bottom) + 1)
    }
    
    func sign() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月d日"
        let text = """
        \(sender?.nickname ?? "")
        \(dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(letter!.time))))
        """
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .right
        
        signLabel?.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: signLabel!.font!, NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    @objc func writeLetter() {
        let controller = PWriteLetterViewController()
        if isSender {
            controller.addressee = addressee
        } else {
            controller.addressee = sender
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
