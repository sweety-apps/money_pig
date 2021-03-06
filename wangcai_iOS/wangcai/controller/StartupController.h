//
//  StartupController.h
//  wangcai
//
//  Created by 1528 on 13-12-26.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UICustomAlertView.h"

@interface StartupController : UIViewController< LoginAndRegisterDelegate, UIAlertViewDelegate> {
    AppDelegate* _delegate;
    UIAlertView* _alertForceUpdate;
    UIAlertView* _alertError;
    UIAlertView* _alertTips;
}
@property (retain, nonatomic) IBOutlet UIImageView *frontImageView;
@property (retain, nonatomic) IBOutlet UIImageView *frontWordsImageView;
@property (retain, nonatomic) IBOutlet UIImageView *logoImageView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (id) init : (AppDelegate*) delegate;
@end
