//
//  SiWeiAdConfigur.h
//  ADconfig
//
//  Created by wisdome on 14-1-7.
//  Copyright (c) 2014年 wisdome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiWeiAdConfig : NSObject
/**
 appid为用户申请的用户ID
 详解:
 前往指盟主页:http://www.mobsmar.com 注册一个开发者帐户，同时注册一个应用，获取对应应用的ID
 **/
+ (void)launchWithAppID:(NSString *)appid ;


// 用于指盟与开发者服务器积分对接,设置自定义参数,参数可以传递给对接服务器
// 参数 需要传递给对接服务器的自定义参数
+ (void)setDeveloperParam:(NSString*)CustomText;
@end
