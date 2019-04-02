//
//  ViewController.swift
//  threeStagePanGesture-Swift
//
//  Created by 杜奎 on 2019/4/2.
//  Copyright © 2019 du. All rights reserved.
//

import UIKit

// iPhone X
func isIPhoneXType() -> Bool {
    guard #available(iOS 11.0, *) else {
        return false
    }
    return UIApplication.shared.windows.first?.safeAreaInsets.bottom != 0
}
let kIPhoneX: Bool = isIPhoneXType()
let kTabbarSafeBottomMargin: CGFloat = kIPhoneX ? 34.0 : 0.0
let kStatusBarAndNavigationBarHeight: CGFloat = kIPhoneX ? 88.0 : 64.0

class ViewController: UIViewController {

    private var bottomBarGestureHandler: GenericPanGestureHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(red: 153.0/255.0, green: 204.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        
        self.view.addSubview(self.bottomBar)
        self.view.addSubview(self.bottomOperateView)
        
        self.bottomBar.bottom = self.view.height
        self.bottomOperateView.y = self.bottomBar.bottom
        
        
        self.bottomBarGestureHandler = GenericPanGestureHandler.init(gestureView: bottomBarCoverView, handleView: bottomBar, minY: kStatusBarAndNavigationBarHeight, midY: self.view.height - 315 - kTabbarSafeBottomMargin, maxY: self.view.height - bottomBar.height)
        self.bottomBarGestureHandler?.offsetCompleteBlock = {
            print("do something")
        }
        self.bottomBarGestureHandler?.offsetChangeBlock = { [weak self] afterY, _,direction in
            self?.bottomOperateView.y = self?.bottomBar.bottom ?? 0
            if afterY < (self?.view.height ?? 0) - 267 - 48 {
                self?.bottomOperateView.height = (self?.view.height ?? 0) - (self?.bottomOperateView.y ?? 0)
            }else {
                self?.bottomOperateView.height = 267
            }
            if afterY < self!.view.height && self!.bottomOperateView.isHidden {
                self?.bottomOperateView.isHidden = false
            }
        }
        self.bottomBarGestureHandler?.shouldResponseGesture = {
            return true
        }
        // Do any additional setup after loading the view.
    }

    //MARK:- setter & getter
    
    private lazy var bottomBar: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 48))
        view.addSubview(bottomBarCoverView)

        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        view.layer.shadowOpacity = Float(0.14)
        view.layer.shadowRadius = 3
        
        let label = UILabel.init()
        label.text = "拖拽我 Drag me"
        label.textColor = UIColor.black
        label.sizeToFit()
        view.addSubview(label)
        label.centerX = view.width * 0.5
        label.centerY = view.height * 0.5
        
        return view
    }()
    
    private lazy var bottomBarCoverView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 48))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var bottomOperateView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 267 + kTabbarSafeBottomMargin))
        view.backgroundColor = UIColor.init(red: 1.0, green: 102.0/255.0, blue: 0, alpha: 1.0)
        return view
    }()
}

