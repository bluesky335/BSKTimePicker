//
//  BSKTimePicker.h
//  TestProject
//
//  Created by aaaa on 16/9/13.
//  Copyright © 2016年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSKTimePicker;

@protocol BSKTimPickerDelegate <NSObject>
@optional
-(void)BSKTimePiker:(BSKTimePicker *)timePicker timeDidChangedWithHours:(NSInteger)hours Minutes:(NSInteger)minutes Seconds:(NSInteger)seconds;
-(void)BSKTimePiker:(BSKTimePicker *)timePicker DidSelectedTimeWithHours:(NSInteger)hours Minutes:(NSInteger)minutes Seconds:(NSInteger)seconds;
@end

@interface BSKTimePicker : UIView
@property (nonatomic,weak)id<BSKTimPickerDelegate> delegate;
@property (nonatomic,assign,readonly) NSInteger hours;//小时
@property (nonatomic,assign,readonly) NSInteger minutes;//分钟
@property (nonatomic,assign,readonly) NSInteger seconds;//秒
@property (nonatomic,assign) CGFloat minutesPointSize;//分钟圆点的大小（直径）
@property (nonatomic,assign) CGFloat secondsPointSize;//秒圆点的大小（直径）
@property (nonatomic,strong) UIColor * textColor;//时钟文字的颜色
@property (nonatomic,strong) UIColor * minutesPointColor;//分钟圆点的颜色
@property (nonatomic,strong) UIColor * secondsPointColor;//秒钟圆点的颜色
@property (nonatomic,strong) UIColor * minutesCircleColor;//分钟圆圈的颜色
@property (nonatomic,strong) UIColor * secondsCircleColor;//秒钟圆圈的颜色
-(CGPoint) centerPoint;
@end
