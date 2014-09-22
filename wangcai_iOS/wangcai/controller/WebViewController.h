//
//  WebViewController.h
//  wangcai
//
//  Created by 1528 on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegister.h"
#import "EGORefreshTableHeaderView.h"

@protocol WebViewControllerDelegate <NSObject>
- (void) openAppWithIdentifier : (NSString*) appid;
- (void) openUrl : (NSString*) url;
@end

@interface WebViewController : UIViewController<UIScrollViewDelegate, UIWebViewDelegate, UIAlertViewDelegate, BindPhoneDelegate, BalanceChangeDelegate, EGORefreshTableHeaderDelegate> {
    UIWebView* _webView;
    NSString*  _url;
    
    UIView*    _loadingView;
    UIView*    _errView;
    
    BeeUIStack* _beeStack;
    
    id _delegate;
    
    UIAlertView*    _alert;
    NSString*       _nsCallback;
    NSString*       _nsBtn2ID;
    
    UIAlertView*    _alertBindPhone;
    UIAlertView*    _alertNoBalance;
    
    CGSize          _size;
    
    EGORefreshTableHeaderView* _refreshHeaderView;
    BOOL            _reloading;
    
    BOOL            _refreshHeader;
}

- (void) setDelegate:(id) delegate;

- (id)init;
- (void)setBeeUIStack:(BeeUIStack*) beeStack;
- (void)setNavigateUrl:(NSString*)url;

- (void)notifyPhoneStatus:(BOOL)isAttach Phone:(NSString*)phone Balance:(float)banlance;

- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)setSize:(CGSize) size;

- (IBAction)onRequest:(id)sender;
@end
