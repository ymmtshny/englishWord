//
//  UIColor.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/06/28.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func rgb(r r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
        
    }
    
    class func MainColor() -> UIColor {
        
        return UIColor.rgb(r: 24, g: 135, b: 208, alpha: 1.0)
        
    }
    
    
    class func lightBlue() -> UIColor {
            return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
        }
        
    class func lightRed() -> UIColor {
            return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
        }
}