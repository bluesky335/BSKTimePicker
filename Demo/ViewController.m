//
//  ViewController.m
//  BSKTimePicker
//
//  Created by aaaa on 16/9/23.
//  Copyright © 2016年 bluesky335. All rights reserved.
//

#import "ViewController.h"
#import "BSKTimePicker.h"
@interface ViewController ()<BSKTimPickerDelegate>
@property (nonatomic,strong) BSKTimePicker * timePicker;
@property (nonatomic,strong) UILabel * timeLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor= [UIColor colorWithRed:0.0f  green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0];
    self.timePicker = [[BSKTimePicker alloc]initWithFrame:CGRectMake(50, 100, 200, 200)];
    self.timePicker.center = self.view.center;
    self.timePicker.minutesPointColor = [UIColor colorWithRed:1.0f green:87.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
    self.timePicker.secondsPointColor = [UIColor colorWithRed:0.0f green:150.0f/255.0f blue:1.0f alpha:1.0f];
    self.timePicker.minutesCircleColor = [UIColor whiteColor];
    self.timePicker.secondsCircleColor = [UIColor whiteColor];
    self.timePicker.textColor = [UIColor whiteColor];
    self.timePicker.delegate = self;
    [self.view addSubview:self.timePicker];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.text = @"当前时间:00:00:00";
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont systemFontOfSize:30];
    self.timeLabel.frame = CGRectMake(0, 50, 400, 50);
    [self.view addSubview:self.timeLabel];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitle:@"+" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(jia) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(200, 100, 100, 100);
    [button2 setTitle:@"-" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(jian) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
}

-(void)jia{
    self.timePicker.seconds+=1;
}
-(void)jian{
    
    self.timePicker.seconds-=1;
}

-(void)BSKTimePiker:(BSKTimePicker *)timePicker DidSelectedTimeWithHours:(NSInteger)hours Minutes:(NSInteger)minutes Seconds:(NSInteger)seconds{
    
    self.timeLabel.text = [NSString stringWithFormat:@"已选择时间:%.2ld:%.2ld:%.2ld",hours,minutes,seconds];
}

-(void)BSKTimePiker:(BSKTimePicker *)timePicker timeDidChangedWithHours:(NSInteger)hours Minutes:(NSInteger)minutes Seconds:(NSInteger)seconds{
    
    self.timeLabel.text = [NSString stringWithFormat:@"当前时间:%.2ld:%.2ld:%.2ld",hours,minutes,seconds];
}


@end
