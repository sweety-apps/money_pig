//
//  StartupController.m
//  wangcai
//
//  Created by 1528 on 13-12-26.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "StartupController.h"
#import "LoginAndRegister.h"
#import "AppBoard_iPhone.h"
#import "AppBoard_iPad.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"
#import <RennSDK/RennSDK.h>
#import "WeiboSDK.h"
#import "CommonTaskList.h"
#import "XMLReader.h"
#import "Config.h"
#import "OnlineWallViewController.h"

@interface StartupController () <CommonTaskListDelegate>

@end

@implementation StartupController

- (id)init : (AppDelegate*) delegate
{
    self = [super initWithNibName:@"StartupController" bundle:nil];
    if (self) {
        // Custom initialization
        _delegate = delegate;
        
        CGSize size = [[UIScreen mainScreen] bounds].size;
        if ( 1.0 * size.height / size.width > 1.0 * 960 / 640 ) {
            self.view = [[[NSBundle mainBundle] loadNibNamed:@"StartupController" owner:self options:nil] objectAtIndex:1];
        } else {
            self.view = [[[NSBundle mainBundle] loadNibNamed:@"StartupController" owner:self options:nil] firstObject];
        }
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        _alertError = nil;
        _alertForceUpdate = nil;
        _alertTips = nil;
        
        // 初始化sharesdk
        [self initShareSDK];
        
        // 登陆
        [[LoginAndRegister sharedInstance] login:self];
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( _alertError != nil && [alertView isEqual:_alertError] ) {
        // 重试
        [[self.view viewWithTag:11] setHidden:NO];
        [[LoginAndRegister sharedInstance] login:self];
    } else if ( _alertForceUpdate != nil && [alertView isEqual:_alertForceUpdate] ) {
        // 升级
        NSString* sysVer = [[UIDevice currentDevice] systemVersion];
        NSString* urlStr = [[[NSString alloc] initWithFormat:@"%@sysVer=%@", WEB_FORCE_UPDATE, sysVer] autorelease];
        
        NSURL* url = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:url];
        
        exit(0);
    } else if ( _alertTips != nil && [alertView isEqual:_alertTips] ) {
        exit(0);
    }
}

-(void) loginCompleted : (LoginStatus) status HttpCode:(int)httpCode ErrCode:(int)errCode Msg:(NSString*)msg {
    [[self.view viewWithTag:11] setHidden:YES];
    
    if ( status == Login_Success ) {
        int forceUpdate = [[LoginAndRegister sharedInstance] getForceUpdate];
        if ( forceUpdate == 1 ) {
            // 强制升级
            if ( _alertForceUpdate != nil ) {
                [_alertForceUpdate release];
            }
            
            _alertForceUpdate = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发现新版赚钱小猪！更安全更好赚，请立即升级。" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil, nil];
            [_alertForceUpdate show];
        } else {
            [[OnlineWallViewController sharedInstance] setFullScreenWindow:_delegate.window];
            
            [CATransaction begin];
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionFade;
            transition.duration = 0.5f;
            transition.fillMode = kCAFillModeForwards;
            transition.removedOnCompletion = YES;
            [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
        
            //任务列表改到登陆协议中去了，已不用单独再拉列表了
            //[[CommonTaskList sharedInstance] fetchTaskList:self];
            [self onFinishedFetchTaskList:[CommonTaskList sharedInstance] resultCode:0];
        
            [CATransaction commit];
            
            NSString* msgTips = [[LoginAndRegister sharedInstance] getTipsStrings];
            if ([msgTips length] > 0)
            {
                NSString* errMsg = [[msgTips copy] autorelease];
                NSRange range = [errMsg rangeOfString:@"$"];
                NSString* title = [errMsg substringToIndex:range.location];
                NSString* body = [errMsg substringFromIndex:range.location + range.length];
                
                UIAlertView* alertTips = [[UIAlertView alloc] initWithTitle:title message:body delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertTips show];
            }
        }
    } else {
        // 登陆错误，必须登陆成功才能进入下一步
        if ( httpCode == 200 && (errCode == 511 || errCode == 403) ) {
            NSString* errMsg = [[msg copy] autorelease];
            NSRange range = [errMsg rangeOfString:@"$"];
            NSString* title = [errMsg substringToIndex:range.location];
            NSString* body = [errMsg substringFromIndex:range.location + range.length];
            
            _alertTips = [[UIAlertView alloc] initWithTitle:title message:body delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
            [_alertTips show];
        } else {
            if ( _alertError != nil ) {
                [_alertError release];
            }
            
            if ( msg != nil && [msg length] > 0 ) {
                _alertError = [[UIAlertView alloc]initWithTitle:@"错误" message:msg delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil, nil];
            } else {
                _alertError = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不可用，请检查网络连接" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil, nil];
            }
            [_alertError show];
        }
    }
}

- (void) dealloc {
    if ( _alertError != nil ) {
        [_alertError release];
    }
    
    if ( _alertForceUpdate != nil ) {
        [_alertForceUpdate release];
    }
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initShareSDK {
    [ShareSDK registerApp:@"3d33b9806a6c"];
    
    // 新浪微博
    [ShareSDK connectSinaWeiboWithAppKey: @"2574513086" appSecret: @"95b577420870440927287600606a83d9" redirectUri: @"https://api.weibo.com/oauth2/default.html" weiboSDKCls: [WeiboSDK class]];
    
    // 添加QQ应用
    [ShareSDK connectQQWithQZoneAppKey:@"1103369545"                 //该参数填入申请的QQ AppId
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    // 微信
    // wxb36cb2934f410866
    
    [ShareSDK connectWeChatWithAppId: @"wxf3b81b618060b1fc" wechatCls: [WXApi class]];
            
    // 微信朋友圈
    [ShareSDK connectWeChatTimelineWithAppId: @"wxf3b81b618060b1fc" wechatCls: [WXApi class]];
    
    // 微信好友
    [ShareSDK connectWeChatSessionWithAppId: @"wxf3b81b618060b1fc" wechatCls: [WXApi class]];
    
    // 豆瓣
    [ShareSDK connectDoubanWithAppKey: @"0d9c9584fb4ecf4328d5c08ef1ec6dc9" appSecret: @"68634119648e5dd3" redirectUri: @"http://dev.kumoway.com/braininference/infos.php"];
    
    // 腾讯微博
    [ShareSDK connectTencentWeiboWithAppKey: @"801546594" appSecret: @"31189f068f46f828c76edfb7e8594346" redirectUri: @"http://www.bghills.com/app" wbApiCls: [WeiboApi class]];
    
    // 短信
    [ShareSDK connectSMS];
    
    // 邮件
    [ShareSDK connectMail];
    
    // 拷贝
    [ShareSDK connectCopy];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark <CommonTaskListDelegate>

- (void)onFinishedFetchTaskList:(CommonTaskList*)taskList resultCode:(NSInteger)result
{
    if (result >= 0)
    {
        
    }
    else
    {
        
    }
    
    //if ( [BeeSystemInfo isDevicePad] ) {
    //    _delegate.window.rootViewController = [AppBoard_iPad sharedInstance];
    //} else {
        _delegate.window.rootViewController = [AppBoard_iPhone sharedInstance];
    //}
}
@end
