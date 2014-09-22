//
//  UILevelUpAlertView.h
//  wangcai
//
//  Created by Lee Justin on 14-2-22.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UILevelUpAlertView;

@protocol UILevelUpAlertViewDelegate <NSObject>

- (void)onPressedCloseUILevelUpAlertView:(UILevelUpAlertView*)alertView;
- (void)onPressedCheckLevelUILevelUpAlertView:(UILevelUpAlertView*)alertView;

@end


@interface UILevelUpAlertView : UIView
{
    UIView* _bgView;
    id<UILevelUpAlertViewDelegate> _delegate;
}

+ (UILevelUpAlertView*)sharedInstance;

- (void) setLevel:(int)level level:(int)levelChange; //1-5

- (id)init;

- (void) show;
- (void) hideAlertView;
- (void) setDelegate:(id<UILevelUpAlertViewDelegate>)delegate;

@end
