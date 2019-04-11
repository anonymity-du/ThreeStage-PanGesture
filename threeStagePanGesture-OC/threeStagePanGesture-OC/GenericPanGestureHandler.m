//
//  GenericPanGestureHandler.m
//  threeStagePanGesture-OC
//
//  Created by 杜奎 on 2019/4/11.
//  Copyright © 2019 du. All rights reserved.
//

#import "GenericPanGestureHandler.h"
#import "UIView+Extension.h"

//发布动态的键盘状态
typedef NS_ENUM(NSInteger, BottomBarLevelType) {
    BottomBarLevelTypeMin = 0,
    BottomBarLevelTypeMid,
    BottomBarLevelTypeMax
};

@interface GenericPanGestureHandler ()

//操作的对象视图
@property (nonatomic, weak) UIView *handleView;
//手势的对象视图
@property (nonatomic, weak) UIView *gestureView;
//当前的手势触发位置
@property (nonatomic, assign) CGPoint currentPoint;
//当前的拖动方向
@property (nonatomic, assign) BOOL directionUp;

//最小的Y值
@property (nonatomic, assign, readwrite) CGFloat minY;
//中间的Y值
@property (nonatomic, assign, readwrite) CGFloat midY;
//最大的Y值
@property (nonatomic, assign, readwrite) CGFloat maxY;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) BottomBarLevelType levelType;

@end

@implementation GenericPanGestureHandler

- (instancetype)initWithGestureView:(UIView *)gestureView handleView:(UIView *)handleView minY:(CGFloat)minY midY:(CGFloat)midY maxY:(CGFloat)maxY {
    if (self = [super init]) {
        self.gestureView = gestureView;
        self.handleView = handleView;
        self.minY = minY;
        self.midY = midY;
        self.maxY = maxY;
        _directionUp = YES;
        _currentPoint = CGPointZero;
        _levelType = BottomBarLevelTypeMid;
        
        [gestureView addGestureRecognizer:self.panGesture];
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
    if (self.shouldResponseGesture) {
        if (self.shouldResponseGesture() == false) {
            return;
        }
    }
    
    CGPoint pointInSuperview = [gesture locationInView:self.handleView.superview];
    CGPoint pointVelocity = [gesture velocityInView:self.handleView];
    
    CGFloat afterY = 0;
    CGFloat distance = 0;
    distance = pointInSuperview.y - self.currentPoint.y;
    afterY = self.handleView.y + distance;
    
    //识别器已经接收识别为此手势(状态)的触摸(Began)
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.currentPoint = pointInSuperview;
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        if (afterY <= self.minY) {
            afterY = self.minY;
        }
        self.handleView.y = afterY;
        CGFloat offsetY = 0;
        if (self.levelType == BottomBarLevelTypeMin) {
            offsetY = afterY - self.minY;
        }else if (self.levelType == BottomBarLevelTypeMid) {
            offsetY = afterY - self.midY;
        }else {
            offsetY = afterY - self.maxY;
        }
        if (self.offsetChangeBlock) {
            self.offsetChangeBlock(afterY, offsetY, offsetY < 0);
        }
        self.currentPoint = pointInSuperview;
    }else if (gesture.state == UIGestureRecognizerStateEnded) {
        self.currentPoint = pointInSuperview;
        [self autoBackLocation:pointVelocity];
    }
}

- (void)autoBackLocation:(CGPoint)velocity {
    if (self.handleView == nil) {
        return;
    }
    if (self.handleView.y < self.minY * 0.5 + self.midY * 0.5) {
        if (velocity.y > 50) {
            self.directionUp = false;
            self.levelType = BottomBarLevelTypeMid;
        }else {
            self.directionUp = true;
            self.levelType = BottomBarLevelTypeMin;
        }
    }else if ((self.handleView.y >= self.minY * 0.5 + self.midY * 0.5) && (self.handleView.y < self.maxY * 0.5 + self.midY * 0.5)) {
        if (velocity.y > 50) {
            self.directionUp = false;
            self.levelType = BottomBarLevelTypeMax;
        }else if (velocity.y < -50) {
            self.directionUp = true;
            self.levelType = BottomBarLevelTypeMin;
        }else {
            self.directionUp = self.handleView.y > self.midY;
            self.levelType = BottomBarLevelTypeMid;
        }
    }else if (self.handleView.y >= self.maxY * 0.5 + self.midY * 0.5) {
        if (velocity.y < -50) {
            self.directionUp = true;
            self.levelType = BottomBarLevelTypeMid;
        }else {
            self.directionUp = false;
            self.levelType = BottomBarLevelTypeMax;
        }
    }else {
        
    }
    NSLog(@"是否向上 %d", self.directionUp);
}

#pragma mark - setter & getter

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    }
    return _panGesture;
}

- (void)setLevelType:(BottomBarLevelType)levelType {
    _levelType = levelType;
    __block CGFloat offsetY = 0;
    [UIView animateWithDuration:0.3 animations:^{
        if (levelType == BottomBarLevelTypeMin) {
            offsetY = self.handleView.y - self.minY;
            self.handleView.y = self.minY - self.extraHeight;
            if (self.offsetChangeBlock) {
                self.offsetChangeBlock(self.minY, offsetY, self.directionUp);
            }
        }else if (levelType == BottomBarLevelTypeMid) {
            offsetY = self.handleView.y - self.midY;
            self.handleView.y = self.midY - self.extraHeight;
            if (self.offsetChangeBlock) {
                self.offsetChangeBlock(self.midY, offsetY, self.directionUp);
            }
        }else if (levelType == BottomBarLevelTypeMax) {
            offsetY = self.handleView.y - self.maxY;
            self.handleView.y = self.maxY - self.extraHeight;
            if (self.offsetChangeBlock) {
                self.offsetChangeBlock(self.maxY, offsetY, self.directionUp);
            }
        }
    } completion:^(BOOL finished) {
        if (self.offsetCompleteBlock) {
            self.offsetCompleteBlock();
        }
    }];
}

@end
