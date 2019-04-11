//
//  ViewController.m
//  threeStagePanGesture-OC
//
//  Created by 杜奎 on 2019/4/11.
//  Copyright © 2019 du. All rights reserved.
//

#import "ViewController.h"
#import "GenericPanGestureHandler.h"
#import "UIView+Extension.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
// iPhone X
#define  QX_iPhoneX (SCREENHEIGHT/SCREENWIDTH >= 2.16 ? YES : NO)
#define  QX_TabbarSafeBottomMargin         (QX_iPhoneX ? 34.f : 0.f)
#define  QX_StatusBarAndNavigationBarHeight  (QX_iPhoneX ? 88.f : 64.f)
    
@interface ViewController ()

@property (nonatomic, strong) GenericPanGestureHandler *bottomBarGestureHandler;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIView *bottomBarCoverView;
@property (nonatomic, strong) UIView *bottomOperateView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:204.0/255.0 blue:51.0/255.0 alpha:1.0];
    
    [self.view addSubview:self.bottomBar];
    [self.view addSubview:self.bottomOperateView];
    
    self.bottomBar.bottom = self.view.height;
    self.bottomOperateView.y = self.bottomBar.bottom;

    __weak typeof(self) weakSelf = self;
    self.bottomBarGestureHandler = [[GenericPanGestureHandler alloc] initWithGestureView:self.bottomBarCoverView handleView:self.bottomBar minY:QX_StatusBarAndNavigationBarHeight midY:self.view.height - 315 - QX_TabbarSafeBottomMargin maxY:self.view.height - self.bottomBar.height];
    self.bottomBarGestureHandler.offsetChangeBlock = ^(CGFloat afterY, CGFloat offsetY, BOOL direction) {
        weakSelf.bottomOperateView.y = weakSelf.bottomBar.bottom;
        if (afterY < weakSelf.view.height - 267 - 48) {
            weakSelf.bottomOperateView.height = weakSelf.view.height - self.bottomOperateView.y;
        }else {
            weakSelf.bottomOperateView.height = 267;
        }
        if (afterY < weakSelf.view.height && weakSelf.bottomOperateView.hidden) {
            weakSelf.bottomOperateView.hidden = NO;
        }
    };
    self.bottomBarGestureHandler.shouldResponseGesture = ^BOOL{
        return YES;
    };
    self.bottomBarGestureHandler.offsetCompleteBlock = ^{
        NSLog(@"do something");
    };

    // Do any additional setup after loading the view.
}

#pragma mark - getter

- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 48)];
        [_bottomBar addSubview:self.bottomBarCoverView];
        
        _bottomBar.backgroundColor = [UIColor clearColor];
        _bottomBar.layer.shadowColor = [[UIColor blackColor] CGColor];
        _bottomBar.layer.shadowOffset = CGSizeMake(0, 2);
        _bottomBar.layer.shadowOpacity = 0.14;
        _bottomBar.layer.shadowRadius = 3;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"拖拽我 Drag me";
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        [_bottomBar addSubview:label];
        label.centerX = _bottomBar.width * 0.5;
        label.centerY = _bottomBar.height * 0.5;
    }
    return _bottomBar;
}

- (UIView *)bottomBarCoverView {
    if (!_bottomBarCoverView) {
        _bottomBarCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 48)];
        _bottomBarCoverView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomBarCoverView;
}

- (UIView *)bottomOperateView {
    if (!_bottomOperateView) {
        _bottomOperateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 267 + QX_TabbarSafeBottomMargin)];
        _bottomOperateView.backgroundColor = [UIColor colorWithRed:1.0 green:102.0/255.0 blue:0 alpha:1.0];
    }
    return _bottomOperateView;
}


@end
