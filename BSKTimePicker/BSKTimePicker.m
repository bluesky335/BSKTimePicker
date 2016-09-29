//
//  BSKTimePicker.m
//  TestProject
//
//  Created by aaaa on 16/9/13.
//  Copyright © 2016年 bluesky. All rights reserved.
//

#define BSKABS(x) ((x)>0?(x):-1*(x))
#import "BSKTimePicker.h"
#import "BSKSuperView.h"
#import <AVFoundation/AVFoundation.h>
@interface BSKTimePicker ()
{
    CGFloat minutesViewR;//10/200*superViewWidth
    CGFloat secondsViewR;//2/200*superViewWidth
    CGFloat minutesViewY;//10/200*superViewWidth
    CGFloat secondsViewY;//40/200*superViewWidth
    CGFloat superViewWidth;//Minimum of self.frame.size.width and self.frame.size.height;
}
@property(nonatomic,strong)UIView * minutesView;
@property(nonatomic,strong)UIView * minutesSuperView;
@property(nonatomic,strong)UIView * secondsView;
@property(nonatomic,strong)BSKSuperView * secondsSuperView;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) AVAudioPlayer * player;

@end

@implementation BSKTimePicker

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.isSelecting = NO;
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"timer_turn" ofType:@"wav"];
        NSURL * fileURL = [NSURL fileURLWithPath:filePath];
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL fileTypeHint:@"wav" error:NULL];
        [self.player prepareToPlay];
        [self initializeColors];
        [self initializeUIWithFrame:frame];
        
        UIPanGestureRecognizer * minutesPangesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(minutesPanAction:)];
        [self.minutesView addGestureRecognizer:minutesPangesture];
        UIPanGestureRecognizer * secondsPangesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(secondPanAction:)];
        [self.secondsView addGestureRecognizer:secondsPangesture];
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 200, 200)];
    if (self) {
        
    }
    return self;
}

-(void)initializeColors{
    // @property (nonatomic,strong) UIColor * textColor;//时钟文字的颜色
    // @property (nonatomic,strong) UIColor * minutesPointColor;//分钟圆点的颜色
    // @property (nonatomic,strong) UIColor * secondsPointColor;//秒钟圆点的颜色
    // @property (nonatomic,strong) UIColor * minutesCircleColor;//分钟圆圈的颜色
    // @property (nonatomic,strong) UIColor * secondsCircleColor;//秒钟圆圈的颜色
    self.textColor = [UIColor blackColor];
    self.minutesPointColor = [UIColor redColor];
    self.secondsPointColor = [UIColor blueColor];
    self.minutesCircleColor = [UIColor blueColor];
    self.secondsCircleColor = [UIColor redColor];
}

-(void)initializeUIWithFrame:(CGRect)frame{
    
    self.backgroundColor = [UIColor clearColor];
    
    self.minutesSuperView = [[UIView alloc]init];
    self.minutesSuperView.backgroundColor = [UIColor clearColor];
    self.minutesView = [[UIView alloc]init];

    [self addSubview:self.minutesSuperView];
    [self.minutesSuperView addSubview:self.minutesView];
    
    
    self.secondsSuperView = [[BSKSuperView alloc]init];
    self.secondsSuperView.backgroundColor = [UIColor clearColor];
    
    self.secondsView = [[UIView alloc]init];
    [self addSubview:self.secondsSuperView];
    [self.secondsSuperView addSubview:self.secondsView];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.text = @"00:00:00";
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.userInteractionEnabled = NO;
    [self addSubview:self.timeLabel];
}


- (void)drawRect:(CGRect)rect {
    
    self.minutesView.frame = CGRectMake(self.centerPoint.x-minutesViewR, minutesViewY+(rect.size.height/2-superViewWidth/2), minutesViewR*2, minutesViewR*2);
    self.minutesView.layer.cornerRadius = minutesViewR;
    self.minutesView.backgroundColor = self.minutesPointColor;
    
    self.secondsView.frame = CGRectMake(self.centerPoint.x-secondsViewR, secondsViewY+(rect.size.height/2-superViewWidth/2), secondsViewR*2, secondsViewR*2);
    self.secondsView.layer.cornerRadius = secondsViewR;
    self.secondsView.backgroundColor = self.secondsPointColor;
    
    self.secondsSuperView.frame = self.bounds;
    self.minutesSuperView.frame = self.bounds;
    self.timeLabel.font = [UIFont systemFontOfSize:(25.0/200.0)*superViewWidth];
    self.timeLabel.frame = self.bounds;
    self.timeLabel.textColor = self.textColor;

    [self.minutesCircleColor set]; //设置线条颜色
    UIBezierPath* minutesPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.size.width/2-(superViewWidth/2-minutesViewY*2), rect.size.height/2-(superViewWidth/2-minutesViewY*2), superViewWidth-minutesViewY*4, superViewWidth-minutesViewY*4)];//画圆
    minutesPath.lineWidth = 1;
    minutesPath.lineCapStyle = kCGLineCapRound; //线条拐角
    minutesPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [minutesPath stroke];
    
    [self.secondsCircleColor set];
    UIBezierPath* secondsPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.size.width/2-(superViewWidth/2-minutesViewY*4), rect.size.height/2-(superViewWidth/2-minutesViewY*4), superViewWidth-minutesViewY*8, superViewWidth-minutesViewY*8)];//画圆
    secondsPath.lineWidth = 1;
    secondsPath.lineCapStyle = kCGLineCapRound; //线条拐角
    secondsPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [secondsPath stroke];
}

#pragma mark touchEvent

-(void)minutesPanAction:(UIPanGestureRecognizer *)pangesture{
    switch (pangesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.isSelecting = YES;
            [UIView animateWithDuration:0.1 animations:^{
                _minutesView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            }];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint p =[pangesture locationInView:self];
            CGPoint vector1 = [self getVectorPointWithPoint:self.centerPoint Point:p];
            CGPoint vector2 = [self getVectorPointWithPoint:CGPointMake(0, 0) Point:CGPointMake(0, -1)];
            CGFloat angle=[self getAngleWithVectorPoint:vector2 VectorPoint:vector1];
            NSInteger theTime = (NSInteger)angle/6.0;
            BOOL flag = YES;
            if(self.minutes!=theTime){
                if (BSKABS(theTime - _minutes)>=30) {
                    if (theTime-_minutes>0) {
                        while (_minutes!=0) {
                            self.minutes = self.minutes-1;
                        }
                        if (self.hours!=0) {
                            self.minutes = 59;
                        }else{
                            flag = NO;
                        }
                    }else{
                        while (_minutes!=59) {
                            self.minutes = self.minutes+1;
                        }
                        self.minutes = 0;
                    }
                }
                if (flag) {
                    if (theTime-_minutes>0) {
                        while (_minutes!=theTime) {
                            self.minutes = self.minutes+1;
                        }
                    }else{
                        while (_minutes!=theTime) {
                            self.minutes = self.minutes-1;
                        }
                    }
                }
                
            }
            if (self.hours ==0 && self.minutes == 0) {
                [UIView animateWithDuration:0.1 animations:^{
                    self.minutesSuperView.layer.affineTransform = CGAffineTransformMakeRotation(0);
                }];
            }else{
                [UIView animateWithDuration:0.1 animations:^{
                    self.minutesSuperView.layer.affineTransform = CGAffineTransformMakeRotation((angle/180.0)*M_PI);
                }];
                
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        default:
            [self endSelected];
            break;
    }
}

-(void)secondPanAction:(UIPanGestureRecognizer *)pangesture{
    switch (pangesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.isSelecting = YES;
            [UIView animateWithDuration:0.1 animations:^{
                _secondsView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            }];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint p =[pangesture locationInView:self];
            CGPoint vector1 = [self getVectorPointWithPoint:self.centerPoint Point:p];
            CGPoint vector2 = [self getVectorPointWithPoint:CGPointMake(0, 0) Point:CGPointMake(0, -1)];
            CGFloat angle=[self getAngleWithVectorPoint:vector2 VectorPoint:vector1];
            NSInteger theTime = (NSInteger)angle/6.0;
            BOOL flag = YES;
            if(self.seconds!=theTime){
                if (BSKABS(theTime - _seconds)>=30) {
                    if (theTime-_seconds>0) {
                        
                        while (_seconds!=0) {
                            self.seconds = self.seconds-1;
                        }
                        if (self.hours == 0&&self.minutes==0) {
                            flag = NO;
                        }else{
                            self.seconds = 59;
                        }
                        
                    }else{
                        while (_seconds!=59) {
                            self.seconds = self.seconds+1;
                        }
                        self.seconds = 0;
                    }
                }
                if (flag) {
                    if (theTime-_seconds>0) {
                        while (_seconds!=theTime) {
                            self.seconds = self.seconds+1;
                        }
                    }else{
                        while (_seconds!=theTime) {
                            self.seconds = self.seconds-1;
                        }
                    }
                }
                
            }
            if (self.seconds==0&&self.minutes==0&&self.hours==0) {
                [UIView animateWithDuration:0.1 animations:^{
                    self.secondsSuperView.layer.affineTransform = CGAffineTransformMakeRotation(0);
                }];
            }else{
                [UIView animateWithDuration:0.1 animations:^{
                    self.secondsSuperView.layer.affineTransform = CGAffineTransformMakeRotation((angle/180.0)*M_PI);
                }];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        default:
            [self endSelected];
            break;
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [[event touchesForView:self.minutesView] allObjects].firstObject;
    
    UITouch * touch2 = [[event touchesForView:self.secondsView] allObjects].firstObject;
    
    if(touch){
        [UIView animateWithDuration:0.1 animations:^{
            _minutesView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }];
    }else if(touch2){
        [UIView animateWithDuration:0.1 animations:^{
            _secondsView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.1 animations:^{
        _minutesView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    [UIView animateWithDuration:0.1 animations:^{
        _secondsView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

-(void)endSelected{
    [UIView animateWithDuration:0.1 animations:^{
        _minutesView.transform = CGAffineTransformMakeScale(1, 1);
    }];

    [UIView animateWithDuration:0.1 animations:^{
        _secondsView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.secondsSuperView.layer.affineTransform = CGAffineTransformMakeRotation((self.seconds/30.0)*M_PI);
        self.minutesSuperView.layer.affineTransform = CGAffineTransformMakeRotation((self.minutes/30.0)*M_PI);
    }];
    if (self.delegate&&self.isSelecting) {
        if ([self.delegate respondsToSelector:@selector(BSKTimePiker:DidSelectedTimeWithHours:Minutes:Seconds:)]) {
            [self.delegate BSKTimePiker:self DidSelectedTimeWithHours:self.hours Minutes:self.minutes Seconds:self.seconds];
        }
    }
    self.isSelecting = NO;
}

#pragma mark setter

-(void)setIsSelecting:(BOOL)isSelecting{
    if (_isSelecting!=isSelecting) {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(BSKTimePicker:isSelectingChanged:)]) {
                [self.delegate BSKTimePicker:self isSelectingChanged:isSelecting];
            }
        }
    }
    _isSelecting=isSelecting;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.timeLabel.textColor = textColor;
}

-(void)setMinutesPointColor:(UIColor *)minutesPointColor{
    _minutesPointColor = minutesPointColor;
    self.minutesView.backgroundColor = minutesPointColor;
}

-(void)setMinutesCircleColor:(UIColor *)minutesCircleColor{
    _minutesCircleColor = minutesCircleColor;
    [self setNeedsDisplay];
}
-(void)setSecondsPointColor:(UIColor *)secondsPointColor{
    _secondsPointColor = secondsPointColor;
    self.secondsView.backgroundColor = secondsPointColor;
}
-(void)setSecondsCircleColor:(UIColor *)secondsCircleColor{
    _secondsCircleColor = secondsCircleColor;
    [self setNeedsDisplay];
}

-(void)setMinutesPointSize:(CGFloat)minutesPointSize{
    _minutesPointSize = minutesPointSize;
    self.minutesView.bounds = CGRectMake(0, 0, minutesPointSize, minutesPointSize);
    self.minutesView.layer.cornerRadius = minutesPointSize/2;
}

-(void)setSecondsPointSize:(CGFloat)secondsPointSize{
    _secondsPointSize = secondsPointSize;
    self.secondsView.bounds = CGRectMake(0, 0, secondsPointSize, secondsPointSize);
    self.secondsView.layer.cornerRadius = secondsPointSize/2;
}
     
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    superViewWidth = frame.size.width>frame.size.height?frame.size.height:frame.size.width;
    minutesViewR=10.0/200.0*superViewWidth;
    secondsViewR=7.0/200.0*superViewWidth;
    minutesViewY=10.0/200.0*superViewWidth;
    secondsViewY=35.0/200.0*superViewWidth;
    [self setNeedsDisplay];
}

-(void)setMinutes:(NSInteger)curentTimePoint{
    if (curentTimePoint <0) {
        if(self.hours!=0){
            self.hours-= (labs(curentTimePoint)/60+1);
            curentTimePoint = 60 - (labs(curentTimePoint)%60);
        }else{
            curentTimePoint = 0;
        }
    }else if (curentTimePoint>=60) {
        self.hours += curentTimePoint/60;
    }else if(self.minutes == 59 && curentTimePoint == 0){
        self.hours+=1;
    }
    else if(self.minutes == 0 && curentTimePoint == 59){
        if (self.hours!=0) {
            self.hours -=1;
        }
        
    }
    _minutes = labs(curentTimePoint)%60;
    self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",self.hours,_minutes,_seconds];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(BSKTimePiker:timeDidChangedWithHours:Minutes:Seconds:)]) {
            [self.delegate BSKTimePiker:self timeDidChangedWithHours:self.hours Minutes:self.minutes Seconds:self.seconds];
        }
    }
    if (!self.isSelecting) {
        [UIView animateWithDuration:0.1 animations:^{
            self.minutesSuperView.layer.affineTransform = CGAffineTransformMakeRotation((_minutes/30.0)*M_PI);
        }];
    }
    [self playSound];
    NSLog(@"%.2ld:%.2ld:%.2ld",self.hours,_minutes,_seconds);
}
-(void)setSeconds:(NSInteger)curentSecondsPoint{
    if (curentSecondsPoint<0) {
        if (self.minutes!=0||self.hours!=0) {
            self.minutes-=(labs(curentSecondsPoint)/60+1);
            curentSecondsPoint = 60-(labs(curentSecondsPoint)%60);
        }else{
            curentSecondsPoint = 0;
        }
    }else if (curentSecondsPoint>=60) {
        self.minutes += curentSecondsPoint/60;
    }else if(self.seconds == 59 && curentSecondsPoint == 0){
        if (self.minutes==59) {
            self.minutes=0;
        }else{
            self.minutes+=1;
        }
    }
    else if(self.seconds == 0 && curentSecondsPoint == 59){
        if (self.minutes ==0) {
            if(self.hours!=0){
                self.minutes =59;
            }
        }else{
            self.minutes -=1;
        }
    }
    _seconds = labs(curentSecondsPoint)%60;
    [UIView animateWithDuration:0.1 animations:^{
        self.minutesSuperView.layer.affineTransform = CGAffineTransformMakeRotation((self.minutes/30.0)*M_PI);
    }];
    self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",self.hours,_minutes,_seconds];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(BSKTimePiker:timeDidChangedWithHours:Minutes:Seconds:)]) {
            [self.delegate BSKTimePiker:self timeDidChangedWithHours:self.hours Minutes:self.minutes Seconds:self.seconds];
        }
    }
    if (!self.isSelecting) {
        [UIView animateWithDuration:0.1 animations:^{
            self.secondsSuperView.layer.affineTransform = CGAffineTransformMakeRotation((_seconds/30.0)*M_PI);
        }];
    }
    [self playSound];
    NSLog(@"%.2ld:%.2ld:%.2ld",self.hours,_minutes,_seconds);
}

-(void)setHours:(NSInteger)hours{
    if (hours<0) {
        hours=0;
    }
    _hours = hours;
}



#pragma mark toolFunction

-(void)playSound{
//    if (!self.player.isPlaying) {
        [self.player play];
//    }
}


-(CGPoint) centerPoint{
    return  CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

-(CGFloat) getAngleWithVectorPoint:(CGPoint)vector1 VectorPoint:(CGPoint)vector2{
    return getRotateAngle(vector1.x, vector1.y, vector2.x, vector2.y);
}

double getRotateAngle(double x1, double y1, double x2, double y2)
{
    const double epsilon = 1.0e-6;
    const double nyPI = acos(-1.0);
    double dist, dot, degree, angle;
    
    // normalize
    dist = sqrt( x1 * x1 + y1 * y1 );
    x1 /= dist;
    y1 /= dist;
    dist = sqrt( x2 * x2 + y2 * y2 );
    x2 /= dist;
    y2 /= dist;
    // dot product
    dot = x1 * x2 + y1 * y2;
    if ( fabs(dot-1.0) <= epsilon )
        angle = 0.0;
    else if ( fabs(dot+1.0) <= epsilon )
        angle = nyPI;
    else {
        double cross;
        
        angle = acos(dot);
        //cross product
        cross = x1 * y2 - x2 * y1;
        // vector p2 is clockwise from vector p1
        // with respect to the origin (0.0)
        if (cross < 0 ) {
            angle = 2 * nyPI - angle;
        }
    }
    degree = angle *  180.0 / nyPI;
    return degree;  
}

-(CGPoint) getVectorPointWithPoint:(CGPoint)p1 Point:(CGPoint)p2{
    if (CGPointEqualToPoint(p1, p2)) {//防止出现0向量导致角度计算的死循环
        return CGPointMake(0, -1);
    }
    return CGPointMake(p2.x-p1.x, p2.y-p1.y);
}


@end
