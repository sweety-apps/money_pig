//
//  EcomConfig.h
//  EcomSDK
//
//  Created by DoubleZ on 14-1-21.
//  Copyright (c) 2014年 YouMi Mobile Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EcomConfig : NSObject

+ (void)launchWithAppID:(NSString *)appid appSecret:(NSString *)secret;
// 应用ID
//
// 详解:
//      前往有米主页:http://www.youmi.net/ 注册一个开发者帐户，同时注册一个应用，获取对应应用的ID
//
+ (void)setAppID:(NSString *)appid;
+ (NSString *)appID;

// 安全密钥
//
// 详解:
//      前往有米主页:http://www.youmi.net/ 注册一个开发者帐户，同时注册一个应用，获取对应应用的安全密钥
//
+ (void)setAppSecret:(NSString *)secret;
+ (NSString *)appSecret;


// 设置UserID
//
// 详解:
//      开发者可以设置自己的用户ID，或者将该字段作为回调预留字段使用
//      详情请看：http://wiki.youmi.net/%E5%AF%B9%E5%BC%80%E5%8F%91%E8%80%85%E7%9A%84%E7%A7%AF%E5%88%86%E5%8F%8D%E9%A6%88%E6%8E%A5%E5%8F%A3
//
+ (void)setUserID:(NSString *)userID;
+ (NSString *)userID;

// 请求模式
//
// 详解:
//     默认->模拟器@YES 真机器@NO
//
// 备注:
//     如果YES   将显示测试广告
//     虚拟机将显示测试广告.
//
+ (void)setIsTesting:(BOOL)flag;
+ (BOOL)isTesting;

@end
