//
//  UIGetRedBagAlertView.h
//  wangcai
//
//  Created by Lee Justin on 14-1-23.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIGetRedBagAlertView;

@protocol UIGetRedBagAlertViewDelegate <NSObject>

- (void)onPressedCloseUIGetRedBagAlertView:(UIGetRedBagAlertView*)alertView;
- (void)onPressedGetRmbUIGetRedBagAlertView:(UIGetRedBagAlertView*)alertView;

@end


@interface UIGetRedBagAlertView : UIView
{
    UIView* _bgView;
    id<UIGetRedBagAlertViewDelegate> _delegate;
}

+ (UIGetRedBagAlertView*)sharedInstance;

- (void) setRMBString:(NSString*)rmb;
- (void) setLevel:(int)level; //1-5
- (void) setTitle:(NSString*)title;
- (void) setShowCurrentBanlance:(int)balance andIncrease:(int)increase;

- (id)init;

- (void) show;
- (void) hideAlertView;
- (void) setDelegate:(id<UIGetRedBagAlertViewDelegate>)delegate;

@end
