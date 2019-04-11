//
//  GenericPanGestureHandler.h
//  threeStagePanGesture-OC
//
//  Created by 杜奎 on 2019/4/11.
//  Copyright © 2019 du. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GenericPanGestureHandler : NSObject

//最小的Y值
@property (nonatomic, assign, readonly) CGFloat minY;
//中间的Y值
@property (nonatomic, assign, readonly) CGFloat midY;
//最大的Y值
@property (nonatomic, assign, readonly) CGFloat maxY;
//额外的高度
@property (nonatomic, assign)  CGFloat extraHeight;
//手势变化的位置回调
@property (nonatomic, copy) void (^offsetChangeBlock)(CGFloat afterY, CGFloat offsetY, BOOL direction);
//手势结束的回调
@property (nonatomic, copy) void (^offsetCompleteBlock)(void);
//是否触发手势
@property (nonatomic, copy) BOOL (^shouldResponseGesture)(void);

- (instancetype)initWithGestureView:(UIView *)gestureView handleView:(UIView *)handleView minY:(CGFloat)minY midY:(CGFloat)midY maxY:(CGFloat)maxY;

@end

