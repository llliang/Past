//
//  UIViewExtention.swift
//  Nests
//
//  Created by Neo on 2018/1/24.
//  Copyright © 2018 JiangLiang. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    var origin: CGPoint {
        set (newOrigin) {
            self.frame = CGRect(x: newOrigin.x, y: newOrigin.y, width: self.width, height: self.height)
        }

        get {
            return self.frame.origin
        }
    }

    var width: CGFloat {
        set(newWidth) {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newWidth, height: self.height)
        }

        get {
            return self.frame.size.width
        }
    }

    var height: CGFloat {
        set(newHeight) {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.width, height: newHeight)
        }

        get {
            return self.frame.size.height
        }
    }

    var left: CGFloat {
        set(newLeft) {
            self.frame = CGRect(x: newLeft, y: self.origin.y, width: self.width, height: self.height)
        }

        get {
            return self.frame.origin.x
        }
    }

    var right: CGFloat {
        set(newRight) {
            self.frame = CGRect(x:newRight - self.width, y: self.origin.y, width: self.width, height:
                self.height)
        }

        get {
            return self.left + self.width
        }
    }

    var top: CGFloat {
        set(newTop) {
            self.frame = CGRect(x: self.left, y: newTop, width: self.width, height: self.height)
        }

        get {
            return self.origin.y
        }
    }

    var bottom: CGFloat {
        set(newBottom) {
            self.frame = CGRect(x: self.left, y: self.bottom - self.height, width: self.width, height: self.height)
        }

        get {
            return self.origin.y + self.height
        }
    }
}

