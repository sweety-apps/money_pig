//
//  SiWeiDelegate.h
//  SiWeiAdSimper_banner
//
//  Created by siwei on 13-5-1.
//  Copyright (c) 2013年 siwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SiWeiBannerView;

@protocol SiWeiDelegate <NSObject>
@optional
#pragma mark - 接收到服务器请求的时候调用的方法
/*
 // 请求广告条数据成功后调用
 //
 // 详解:
 //      当接收服务器返回的广告数据成功后调用该方法
 // 补充:
 //      第一次成功返回数据后调用
 //
 */
- (void)siWeiDidReceiveAd:(SiWeiBannerView *)adView;
/*
 // 请求广告条数据失败后调用
 //
 // 详解:
 //      当接收服务器返回的广告数据失败后调用该方法
 //
 
*/
- (void)siWeiDidReceiveAdFailed:(SiWeiBannerView *)adView;

@end
