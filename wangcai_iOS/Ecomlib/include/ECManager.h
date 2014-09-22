//
//  ECManager.h
//  Ecom
//
//  Created by DoubleZ on 13-12-30.
//  Copyright (c) 2013年 YouMi Mobile Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ECManager : NSObject

//////////////////////////////////////////////////////////////////////////////////////////
// 获取ViewController实例
//
// 详解:
//     获取电商墙UINavigationController实例
//
// 备注:
//     请使用presentViewControllerl函数来展示此电商墙UINavigationController
//     或者使用presentModalViewController函数来展示此电商墙UINavigationController
//
@property(nonatomic, readonly) UINavigationController *wallNavController;

//////////////////////////////////////////////////////////////////////////////////////////
// 展示悬浮按钮
//
// 详解:
//     显示悬浮按钮（点击后自动展示电商墙UINavigationController实例）
//
// 备注:
//     配合隐藏悬浮按钮，随时在不想要按钮的情况下隐藏。
//
+ (void)showBtnBoard;

//
// 详解:(可选)
//     隐藏悬浮按钮
//
// 备注:
//     配合显示悬浮按钮，随时在想要按钮的情况下显示。
//
+ (void)hideBtnBoard;

//
// 详解:(可选)
//     设置悬浮按钮位置中心
//
// 备注:
//     可以设置悬浮按钮所在位置中心
//
+ (void)setBtnBoardOriginPosition:(CGPoint)center animate:(BOOL)animate;

//
// 详解:(可选)
//     设置悬浮按钮的背景图,以及高亮时的图片
//
// 备注:
//     需要自定义悬浮按钮样式的开发者可以使用，用来设置悬浮按钮的背景图,以及高亮时的图片
//
+ (void)setBtnBoardBackgroundImage:(UIImage*)backgroundImage withHighlightedImage:(UIImage*)highlightedImage;

//////////////////////////////////////////////////////////////////////////////////////////
//预加载
//
// 详解:(可选)
//     进行电商墙页面预加载
//
// 备注:
//     进行商品数据预加载
//
+ (void)ecWallPreload;

@end
