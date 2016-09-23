//
//  BSKSuperView.m
//  TestProject
//
//  Created by aaaa on 16/9/22.
//  Copyright © 2016年 bluesky. All rights reserved.
//

#import "BSKSuperView.h"

@implementation BSKSuperView            

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView * returnView = [super hitTest:point withEvent:event];

    if (returnView != self) {
        return returnView;
    }
//    if(![self pointInside:point withEvent:event]){
//        return nil;
//    }
//    for (NSInteger index = self.subviews.count-1 ;index>0 ;index--) {
//        UIView * view = self.subviews[index];
//        UIView * touchView = [view hitTest:point withEvent:event];
//        if (touchView) {
//            NSLog(@"%@",touchView);
//            return touchView;
//            break;
//        }
//    }
    return nil;
}


@end
