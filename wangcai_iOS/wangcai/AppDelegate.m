//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "AppDelegate.h"
#import "AppBoard_iPhone.h"
#import "AppBoard_iPad.h"
#import "LoginAndRegister.h"
#import <ShareSDK/ShareSDK.h>
#import "AppBoard_iPhone.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
//#import "WBApi.h"
#import <RennSDK/RennSDK.h>
#import "WeiboSDK.h"
#import "model/MobClick.h"
#import "Config.h"
#import "StartupController.h"
#import "OnlineWallViewController.h"
#import "JPushlib/APService.h"
#import "UtilityFunctions.h"
#import "WebPageController.h"

#import "SiWeiAdConfig.h"
#import "SiWeiPointsManger.h"
#import "SettingLocalRecords.h"

#pragma mark -

@interface AppDelegate ()
{
    StartupController* _startupController;
    NSArray* _gallaryImageNames;
    UIImageView* _gallaryImageView;
}
@property (nonatomic,assign) StartupController* startupController;

@end

@implementation AppDelegate

@synthesize startupController = _startupController;

- (void)load
{
    StartupController* startup = [[StartupController alloc]init : self];
    _nsRemoteNotifications = nil;
    
    _timeRemoteNotifications = 0;
    _startupController = startup;
    
    [CATransaction begin];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 0.5f;
    transition.fillMode = kCAFillModeForwards;
    transition.removedOnCompletion = YES;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    
    self.window.rootViewController = startup;
    
    [CATransaction commit];

    [UIApplication sharedApplication].statusBarHidden = YES;
    
    _gallaryImageNames = [@[
                            @"holding_page_0",
                            @"holding_page_1",
                            @"holding_page_2"
                            ] retain];
    
    [MobClick startWithAppkey:UMENG_KEY];
}

- (void)unload
{
    if (_gallaryImageNames != nil)
    {
        [_gallaryImageNames release];
        _gallaryImageNames = nil;
    }
    
	if ( _nsRemoteNotifications != nil ) {
        [_nsRemoteNotifications release];
    }
    
    if (_gallaryImageView != nil)
    {
        [_gallaryImageView release];
        _gallaryImageView = nil;
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //[super handleOpenURL:url];
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication
                        annotation:annotation wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    if ( launchOptions != nil ) {
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if ( pushNotificationKey ) {
            _nsRemoteNotifications = [pushNotificationKey copy];
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            _timeRemoteNotifications = [dat timeIntervalSince1970]*1000;
        }
    }
    
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
    
    if ( userInfo != nil ) {
        if ( _nsRemoteNotifications != nil ) {
            [_nsRemoteNotifications release];
        }
        _nsRemoteNotifications = [userInfo copy];
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        _timeRemoteNotifications = [dat timeIntervalSince1970]*1000;
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"[Regist Push] Failed, err = %@",error);
    
    if (DEBUG_PUSH)
    {
        [UtilityFunctions debugAlertView:@"推送测试（正式版不出现）" content:[NSString stringWithFormat:@"[Regist Push] Failed, err = %@",error]];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [super applicationDidBecomeActive:application];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            
    [self postNotification:@"applicationDidBecomeActive"];
    
    if ( _nsRemoteNotifications != nil ) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval curTime = [dat timeIntervalSince1970]*1000;
        if ( curTime - _timeRemoteNotifications < 500 ) {
            // 如果小于1s，认为是通过通知来启动的
            //
            [self onShowPageFromRootNotification:_nsRemoteNotifications];
            
            [_nsRemoteNotifications release];
            _nsRemoteNotifications = nil;
        } else {
            [_nsRemoteNotifications release];
            _nsRemoteNotifications = nil;
        }
    }
    
    [self hideBackgroundGalleryImage];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [super applicationDidEnterBackground:application];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self showBackgroundGalleryImage];
    [super applicationWillResignActive:application];
}

-(void) onShowPageFromRootNotification:(NSDictionary*) remoteNotifications {
    NSString* type = [remoteNotifications objectForKey:@"type"];
    if ( ![type isEqualToString:@"1"] ) {
        return ;
    }
    
    NSString* title = [remoteNotifications objectForKey:@"title"];
    NSString* url = [remoteNotifications objectForKey:@"url"];
    
    if ( [self.window.rootViewController isEqual:[AppBoard_iPhone sharedInstance]] ) {
        // 取当前stack
        BeeUIStack* stack = [BeeUIRouter sharedInstance].currentStack;

        WebPageController* controller = [[[WebPageController alloc] init:title
                                                                     Url:url Stack:stack] autorelease];
        [stack pushViewController:controller animated:YES];
    } else {
        // 界面还没有创建
        [[AppBoard_iPhone sharedInstance] openUrlFromRomoteNotification:title Url:url];
    }
}

- (void) showBackgroundGalleryImage
{
    if (![SettingLocalRecords hasAgreedPrivacyPolicy])
    {
        return;
    }
    int index = arc4random_uniform([_gallaryImageNames count]);
    UIImage* img = [UIImage imageNamed:_gallaryImageNames[index]];
    if (_gallaryImageView == nil)
    {
        CGRect rect = self.window.frame;
        rect.origin = CGPointZero;
        _gallaryImageView = [[UIImageView alloc] initWithFrame:rect];
        [self.window addSubview:_gallaryImageView];
        _gallaryImageView.hidden = YES;
    }
    [self.window bringSubviewToFront:_gallaryImageView];
    _gallaryImageView.image = img;
    _gallaryImageView.alpha = 0.0f;
    _gallaryImageView.alpha = 1.0f;
    _gallaryImageView.hidden = NO;
}

- (void) hideBackgroundGalleryImage
{
    if (![SettingLocalRecords hasAgreedPrivacyPolicy])
    {
        return;
    }
    [UIView animateWithDuration:0.15 animations:^(){
        _gallaryImageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        _gallaryImageView.hidden = YES;
    }];
}

@end
