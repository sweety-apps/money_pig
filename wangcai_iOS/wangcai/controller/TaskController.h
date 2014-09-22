//
//  TaskController.h
//  wangcai
//
//  Created by 1528 on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "TabController.h"
#import <StoreKit/StoreKit.h>


@interface TaskController : UIViewController<WebViewControllerDelegate, SKStoreProductViewControllerDelegate> {
    WebViewController* _webViewController;
    TabController* _tabController;
    NSNumber*      _taskId;
}

- (id)init:(NSNumber*)taskId Tab1:(NSString*) tab1 Tab2:(NSString*) tab2 Tab3:(NSString*) tab3 Purse:(float) purse;
- (void) openAppWithIdentifier : (NSString*) appid;
- (IBAction)clickBack:(id)sender;

@end
