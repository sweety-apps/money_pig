//
//  YouMiConfig.h
//  YouMiSDK
//
//  Created by Layne on 12-5-2.
//  Copyright (c) 2012年 YouMi Mobile Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YouMiConfig : NSObject

+ (void)launchWithAppID:(NSString *)appid appSecret:(NSString *)secret;

// Application ID
// Explanation:     Register as developer role in http://www.youmi.net/ , then create an app in control panel after login, and get the AppID for the app
//                  前往有米主页:http://www.youmi.net/ 注册一个开发者帐户，同时注册一个应用，获取对应应用的ID
+ (void)setAppID:(NSString *)appid;
+ (NSString *)appID;



// Security Key
// Explanation:     Register as developer role inhttp://www.youmi.net/ , then create an app in control panel after login, and get the security key for the app
//                  前往有米主页:http://www.youmi.net/ 注册一个开发者帐户，同时注册一个应用，获取对应应用的安全密钥
+ (void)setAppSecret:(NSString *)secret;
+ (NSString *)appSecret;



// We use synchronized request method for online parameters request
// Set up the online parameters in http://www.youmi.net/ Advertisement Setting -> Online Parameters Setting
// 对于在线参数的请求，我们采用的是同步请求的方式
// 设置在线参数请到http://www.youmi.net/ 网站上。广告设置->在线参数设置
+ (id)onlineValueForKey:(NSString *)key;




// Set up the window where full screen ADs showing [suggestion]
// If the app use native ObjectiveC, you can set [YouMiConfi setFullScreenWindow:self.window] after [self.window makeKeyAndVisible] inside [AppDelegate application:didFinishLaunchingWithOptions:]
// 设置全屏广告显示在的window [建议设置]
// 使用原生ObjectiveC代码的APP, 可以在[AppDelegate application:didFinishLaunchingWithOptions:]里[self.window makeKeyAndVisible];后设置[YouMiConfi setFullScreenWindow:self.window];
//
//
// For window code of Unity3D, it hides very deep, no need to set up.
// Unity3D的window代码比较隐藏得比较深，可以不设置
//
//
// For Cocos2d-x, you can set [YouMiConfi setFullScreenWindow:window] after window makeKeyAndVisible] inside [AppController application:didFinishLaunchingWithOptions:]
// Cocos2d-x 可以在[AppController application:didFinishLaunchingWithOptions:]里[window makeKeyAndVisible];后设置[YouMiConfi setFullScreenWindow:window];
//
//
// params window  main_window of app. Usually there is only one window for each app. After the app launches, it will cover the whole screen, all views are inside it.
// params window APP的主window，一般情况下每个APP有且只有一个window，在APP启动完成后生成，覆盖整个屏幕，所有视图都放在它里面.
+ (void)setFullScreenWindow:(UIWindow *)window;




// set up channel number of the publishing app
// 设置应用发布的渠道号
//
// Explanation:
//      This parameter is used for identifying the publishing channel of the app
//      该参数主要用于标识应用发布的渠道
//
// Additional:
//      If you publish the app to App Store, you can set [YouMiConfig setChannelID:100 description:@"App Store"]
//      如果你发布到App Store可以设置[YouMiConfig setChannelID:100 description:@"App Store"]
+ (void)setChannelID:(NSInteger)channel description:(NSString *)desc;
+ (NSInteger)channelID;
+ (NSString *)channelDesc;




// Set up UserID
//
// Explanation:
//      Used for server-toserver virtual currency points obtaining
//      可用于服务器对接获取积分
//      Please refer to:http://wiki.youmi.net/%E5%AF%B9%E5%BC%80%E5%8F%91%E8%80%85%E7%9A%84%E7%A7%AF%E5%88%86%E5%8F%8D%E9%A6%88%E6%8E%A5%E5%8F%A3
+ (void)setUserID:(NSString *)userID;
+ (NSString *)userID;





// Request mode
//
// Explanation:
//     Default->Monitor@YES Real Machine@NO
//     默认->模拟器@YES 真机器@NO
//
// Notes:
//     If yes, Banner will show the testing ADs
//     如果YES  Banner 将显示测试广告
+ (void)setIsTesting:(BOOL)flag;
+ (BOOL)isTesting;




// Statistical localization request
// 统计定位请求
// Default:
//      @YES
// Explanation:
//      The return value indicates if it is allowed to use GPS to positioning user's coordinates. This is mainly used in pushing ADs according to user's area
//      返回是否允许使用GPS定位用户所在的坐标，目前开参数主要用于帮助推送消息的时候选择地区推送
+ (void)setShouldGetLocation:(BOOL)flag;
+ (BOOL)shouldGetLocation;




// If allowed to install APP using iOS6 new features SKStoreProductViewController from iOS6 device
// 是否在iOS6设备上使用iOS6新特性 SKStoreProductViewController 来安装APP
// Default:
//      @YES
// Explanation:
//      If yes, that means the APP can't be downloaded and installed through SKStoreProductViewController before it is published to AppStore.
//      It can be set to "No" during testing period. Set it to be "Yes" before upload the APP to AppStore.
//      如果YES，则在APP没通过 appstore 发布之前没法从 SKStoreProductViewController 中下载安装APP.
//      可以在测试期间设置为 NO, 上传到 appstore 前设置为 YES.
+ (void)setUseInAppStore:(BOOL)flag;
+ (BOOL)useInAppStore;



// Setting the currency unit name, the default value is "coin"
// 设置货币单位，默认是金币
+ (void)setUnitName:(NSString *)name;
@end
