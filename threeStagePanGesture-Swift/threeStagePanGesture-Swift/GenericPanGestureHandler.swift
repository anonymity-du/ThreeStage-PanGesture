//
//  GenericPanGestureHandler.swift
//  DatePlay
//
//  Created by 杜奎 on 2019/3/22.
//  Copyright © 2019 AimyMusic. All rights reserved.
//

import UIKit

//发布动态的键盘状态
enum BottomBarLevelType {
    case min
    case mid
    case max
}

//本手势处理类 主要处理三段式的手势拖动效果，用此类抽象出来，不用重复写
class GenericPanGestureHandler: NSObject {
    //操作的对象视图
    weak var handleView: UIView?
    //手势的对象视图
    weak var gestureView: UIView?
    //最小的Y值
    var minY: CGFloat = 0
    //中间的Y值
    var midY: CGFloat = 0
    //最大的Y值
    var maxY: CGFloat = 0
    //额外的高度
    var extraHeight: CGFloat = 0
    
    //当前的手势触发位置
    private var currentPoint: CGPoint = CGPoint.zero
    //当前的拖动方向
    private var directionUp: Bool = true
    //手势变化的位置回调
    var offsetChangeBlock: ((_ afterY: CGFloat,_ offsetY: CGFloat,_ direction: Bool?)->())?
    //手势结束的回调
    var offsetCompleteBlock: (()->())?
    //是否触发手势
    var shouldResponseGesture: (()->(Bool))?
    
    convenience init(gestureView: UIView,handleView: UIView, minY: CGFloat, midY: CGFloat, maxY: CGFloat) {
        self.init()
        
        self.gestureView = gestureView
        self.handleView = handleView
        self.minY = minY
        self.midY = midY
        self.maxY = maxY
        gestureView.addGestureRecognizer(self.panGesture)
    }
    
    override init() {
        super.init()
        
    }
    
    @objc private func panAction(gesture: UIPanGestureRecognizer) {
        if self.shouldResponseGesture != nil {
            if (self.shouldResponseGesture!()) == false {
                return
            }
        }
        
        let pointInSuperview = gesture.location(in: self.handleView?.superview)
        let pointVelocity = gesture.velocity(in: self.handleView)
        
        var afterY: CGFloat = 0
        var distance: CGFloat = 0
        distance = pointInSuperview.y - self.currentPoint.y
        afterY = (self.handleView?.y ?? 0) + distance
        
        switch (gesture.state) {
        case .began://识别器已经接收识别为此手势(状态)的触摸(Began)
            self.currentPoint = pointInSuperview;
        case .changed:// 识别器已经接收到触摸，并且识别为手势改变(Changed)
            if (afterY <= self.minY) {
                afterY = self.minY;
            }
            self.handleView?.y = afterY;
            var offsetY: CGFloat = 0
            if self.levelType == .min {
                offsetY = afterY - self.minY
            }else if self.levelType == .mid {
                offsetY = afterY - self.midY
            }else {
                offsetY = afterY - self.maxY
            }
            if offsetChangeBlock != nil {
                offsetChangeBlock!(afterY, offsetY, nil);
            }
            self.currentPoint = pointInSuperview;
        case .ended:// 识别器已经接收到触摸，并且识别为手势结束(Ended)
            self.currentPoint = pointInSuperview;
            autoBackLocation(velocity: pointVelocity)
        default:
            break
        }
    }
    
    private func autoBackLocation(velocity: CGPoint) {
        
        guard let view = self.handleView else {
            return
        }
        
        if view.y < self.minY * 0.5 + self.midY * 0.5 {
            if velocity.y > 50 {
                self.directionUp = false
                self.levelType = .mid
            }else {
                self.directionUp = true
                self.levelType = .min
            }
        }else if (view.y >= self.minY * 0.5 + self.midY * 0.5) && (view.y < self.maxY * 0.5 + self.midY * 0.5) {
            if velocity.y > 50 {
                self.directionUp = false
                self.levelType = .max
            }else if velocity.y < -50 {
                self.directionUp = true
                self.levelType = .min
            }else {
                self.directionUp = view.y > self.midY
                self.levelType = .mid
            }
        }else if view.y >= self.maxY * 0.5 + self.midY * 0.5 {
            if velocity.y < -50 {
                self.directionUp = true
                self.levelType = .mid
            }else {
                self.directionUp = false
                self.levelType = .max
            }
        }else {
            print("哈哈哈")
        }
        print("是否向上  \(self.directionUp)")
    }
    
    //MARK:- setter & getter
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(gesture:)))
        return gesture
    }()
    
    var levelType: BottomBarLevelType = .mid {
        didSet {
            UIView.animate(withDuration: 0.3, animations: {
                var offsetY: CGFloat = 0
                switch self.levelType {
                case .min:
                    offsetY = (self.handleView?.y ?? 0) - self.minY
                    self.handleView?.y = self.minY - self.extraHeight
                    if self.offsetChangeBlock != nil {
                        self.offsetChangeBlock!(self.minY, offsetY,self.directionUp);
                    }
                case .mid:
                    offsetY = (self.handleView?.y ?? 0) - self.midY
                    self.handleView?.y = self.midY - self.extraHeight
                    if self.offsetChangeBlock != nil {
                        self.offsetChangeBlock!(self.midY, offsetY,self.directionUp);
                    }
                case .max:
                    offsetY = (self.handleView?.y ?? 0) - self.maxY
                    self.handleView?.y = self.maxY - self.extraHeight
                    if self.offsetChangeBlock != nil {
                        self.offsetChangeBlock!(self.maxY, offsetY,self.directionUp);
                    }
                }
            }) { _ in
                if self.offsetCompleteBlock != nil {
                    self.offsetCompleteBlock!()
                }
            }
        }
    }
    
}
