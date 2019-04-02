//
//  UIView+Extension.swift
//  ImitationOfTodayNews
//
//  Created by 杜奎 on 2017/5/24.
//  Copyright © 2017年 杜奎. All rights reserved.
//

import Foundation
import UIKit

enum OscillatoryAnimationType {
    case bigger
    case smaller
}

extension UIView{
    var x : CGFloat {
        get {
            return frame.origin.x
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    var y : CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    var width : CGFloat {
        get {
            return frame.size.width
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    var height : CGFloat {
        get {
            return frame.size.height
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    
    var centerX : CGFloat {
        get {
            return center.x
        }
        set {
            var tempCenter : CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    var centerY : CGFloat {
        get {
            return center.y
        }
        set {
            var tempCenter : CGPoint = center
            tempCenter.y = newValue
            center = tempCenter
        }
    }
    var size : CGSize {
        get {
            return frame.size
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    var right : CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.x = newValue - frame.size.width
            frame = tempFrame
        }
    }
    
    var bottom : CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.y = newValue - frame.size.height
            frame = tempFrame
        }
    }
    
    func createGenericShadowLayer(radius: CGFloat) -> CALayer {
        return self.createShadowLayer(shadowColor: UIColor.black, size: CGSize.init(width: 0, height: 2), opacity: 0.14, shadowRadius: 3, cornerRadius: radius)
    }
    
    func createShadowLayer(shadowColor: UIColor, size: CGSize, opacity: CGFloat, shadowRadius: CGFloat, cornerRadius: CGFloat) -> CALayer {
        let subLayer = CALayer.init()
        subLayer.frame = self.frame
        subLayer.cornerRadius = cornerRadius
        subLayer.backgroundColor = UIColor.white.cgColor
        subLayer.masksToBounds = false
        subLayer.shadowColor = shadowColor.cgColor
        subLayer.shadowOffset = size
        subLayer.shadowOpacity = Float(opacity)
        subLayer.shadowRadius = shadowRadius
        return subLayer
    }
    
    func createCorner(bounds: CGRect, rectCorner: UIRectCorner, cornerRadius: CGFloat){
        if self.layer.mask != nil {
            return
        }
        if bounds.width == 0 || bounds.height == 0 {
            return
        }
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius))
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = maskPath.cgPath
        shapeLayer.frame = bounds
        self.layer.mask = shapeLayer
    }
    
    class func showOscillatoryAnimation(layer: CALayer, type: OscillatoryAnimationType) {
        let animationScale1 = (type == .bigger ? 1.15 : 0.5)
        let animationScale2 = (type == .bigger ? 0.92 : 1.15)
        
        UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
            layer.setValue(animationScale1, forKeyPath: "transform.scale")
        }) { (finished) in
            UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
                layer.setValue(animationScale2, forKeyPath: "transform.scale")
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
                    layer.setValue(1.0, forKeyPath: "transform.scale")
                }, completion: nil)
            })
        }
    }
}
