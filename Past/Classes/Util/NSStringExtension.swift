//
//  NSStringExtension.swift
//  Past
//
//  Created by jiangliang on 2018/3/22.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation
import UIKit

extension NSString {
    func size(withFont font: UIFont, constrainedSize: CGSize) -> CGSize {
        return self.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font : font], context: nil).size
    }
}
