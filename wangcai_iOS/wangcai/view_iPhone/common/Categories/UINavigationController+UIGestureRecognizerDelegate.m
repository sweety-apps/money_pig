//
//  UINavigationController+UIGestureRecognizerDelegate.m
//  wangcai
//
//  Created by Lee Justin on 14-10-21.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "UINavigationController+UIGestureRecognizerDelegate.h"

@implementation UINavigationController (UIGestureRecognizerDelegate)

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
