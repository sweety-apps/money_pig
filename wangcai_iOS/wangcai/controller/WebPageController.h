//
//  WebPageController.h
//  wangcai
//
//  Created by 1528 on 13-12-17.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import <StoreKit/StoreKit.h>

@interface WebPageController : UIViewController<WebViewControllerDelegate> {
    BeeUIStack* _beeUIStack;
    UILabel* _titleLabel;
    WebViewController* _webViewController;
}

- (IBAction)clickBack:(id)sender;

- (id)init:(NSString *)title Url : (NSString*) url Stack : (BeeUIStack*) stack;
- (id)initOrder:(NSString *)orderNum Url : (NSString*) url Stack : (BeeUIStack*) stack; // 显示订单信息
@end
