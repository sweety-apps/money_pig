//
//  UICustomAlertView.h
//  wangcai
//
//  Created by 1528 on 14-1-7.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UICustomAlertView : UIView
{
    UIView* _alertView;
    UIView* _bgView;
    
}

- (id)init:(UIView*) alertView;

-(void) show;
- (void) hideAlertView;

@end