//
//  StringExtension.swift
//  Past
//
//  Created by jiangliang on 2018/3/25.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
//    func md5() -> String {
//
//        let cStr = self.cString(using: .utf8)
//        let strLen = self.lengthOfBytes(using: .utf8)
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//
//        CC_MD5(cStr!, CC_LONG(strLen), result)
//        let hash = NSMutableString()
//        for c in cStr! {
//            hash.appendFormat("%02x", c)
//        }
//        result.deallocate(capacity: digestLen)
//
//        //        const char *cStr = [str UTF8String];
//        //        unsigned char result[16];
//        //        CC_MD5( cStr, (uint32_t)strlen(cStr),result );
//        //        NSMutableString *hash =[NSMutableString string];
//        //        for (int i = 0; i < 16; i++)
//        //        [hash appendFormat:@"%02X", result[i]];
//        //        return [hash lowercaseString];
//        return hash as String
//    }
    
    func urlEncode() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    func urlDecode() -> String {
        return self.removingPercentEncoding!
    }
    
    func size(font: UIFont, constrainedSize: CGSize) -> CGSize {
        let nString = self as NSString
        
        return nString.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font], context: nil).size
    }
}
